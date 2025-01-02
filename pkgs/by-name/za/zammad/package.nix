{
  stdenvNoCC,
  lib,
  nixosTests,
  fetchFromGitHub,
  applyPatches,
  bundlerEnv,
  defaultGemConfig,
  callPackage,
  procps,
  ruby,
  postgresql,
  imlib2,
  jq,
  moreutils,
  nodejs,
  pnpm,
  cacert,
  redis,
  dataDir ? "/var/lib/zammad",
}:

let
  pname = "zammad";
  version = "6.4.0";

  src = applyPatches {
    src = fetchFromGitHub (lib.importJSON ./source.json);
    patches = [
      ./fix-sendmail-location.diff
    ];

    postPatch = ''
      sed -i -e "s|ruby '3.2.[0-9]\+'|ruby '${ruby.version}'|" Gemfile
      sed -i -e "s|ruby 3.2.[0-9]\+p[0-9]\+|ruby ${ruby.version}|" Gemfile.lock
      sed -i -e "s|3.2.[0-9]\+|${ruby.version}|" .ruby-version
      ${jq}/bin/jq '. += {name: "Zammad", version: "${version}"}' package.json | ${moreutils}/bin/sponge package.json
    '';
  };

  rubyEnv = bundlerEnv {
    name = "${pname}-gems-${version}";
    inherit version;

    # Which ruby version to select:
    #   https://docs.zammad.org/en/latest/prerequisites/software.html#ruby-programming-language
    inherit ruby;

    gemdir = src;
    gemset = ./gemset.nix;
    groups = [
      "assets"
      "unicorn" # server
      "test"
      "mysql"
      "puma"
      "development"
      "postgres" # database
    ];
    gemConfig = defaultGemConfig // {
      pg = attrs: {
        buildFlags = [ "--with-pg-config=${lib.getDev postgresql}/bin/pg_config" ];
      };
      rszr = attrs: {
        buildInputs = [
          imlib2
          imlib2.dev
        ];
        buildFlags = [ "--without-imlib2-config" ];
      };
      mini_racer = attrs: {
        buildFlags = [
          "--with-v8-dir=\"${nodejs.libv8}\""
        ];
        dontBuild = false;
        postPatch = ''
          substituteInPlace ext/mini_racer_extension/extconf.rb \
            --replace Libv8.configure_makefile '$CPPFLAGS += " -x c++"; Libv8.configure_makefile'
        '';
      };
    };
  };

in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  buildInputs = [
    rubyEnv
    rubyEnv.wrappedRuby
    rubyEnv.bundler
  ];

  nativeBuildInputs = [
    redis
    postgresql
    pnpm.configHook
    nodejs
    procps
    cacert
  ];

  env.RAILS_ENV = "production";

  pnpmDeps = pnpm.fetchDeps {
    inherit pname src;

    hash = "sha256-bdm1nkJnXE7oZZhG2uBnk3fYhITaMROHGKPbf0G3bFs=";
  };

  buildPhase = ''
    mkdir redis-work
    pushd redis-work
    redis-server &
    REDIS_PID=$!
    popd

    mkdir postgres-work
    initdb -D postgres-work --encoding=utf8
    pg_ctl start -D postgres-work -o "-k $PWD/postgres-work -h '''"
    createuser -h $PWD/postgres-work zammad -R -S
    createdb -h $PWD/postgres-work --encoding=utf8 --owner=zammad zammad

    rake DATABASE_URL="postgresql:///zammad?host=$PWD/postgres-work" assets:precompile

    kill $REDIS_PID
    pg_ctl stop -D postgres-work -m immediate
    rm -r redis-work postgres-work
  '';

  installPhase = ''
    cp -R . $out
    rm -rf $out/config/database.yml $out/config/secrets.yml $out/tmp $out/log
    # dataDir will be set in the module, and the package gets overriden there
    ln -s ${dataDir}/config/database.yml $out/config/database.yml
    ln -s ${dataDir}/config/secrets.yml $out/config/secrets.yml
    ln -s ${dataDir}/tmp $out/tmp
    ln -s ${dataDir}/log $out/log
  '';

  passthru = {
    inherit rubyEnv;
    updateScript = [
      "${callPackage ./update.nix { }}/bin/update.sh"
      pname
      (toString ./.)
    ];
    tests = {
      inherit (nixosTests) zammad;
    };
  };

  meta = with lib; {
    description = "Zammad, a web-based, open source user support/ticketing solution";
    homepage = "https://zammad.org";
    license = licenses.agpl3Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      taeer
      netali
    ];
  };
}
