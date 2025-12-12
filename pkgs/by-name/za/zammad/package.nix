{
  stdenvNoCC,
  lib,
  nixosTests,
  fetchFromGitHub,
  applyPatches,
  bundlerEnv,
  callPackage,
  procps,
  ruby,
  postgresql,
  jq,
  moreutils,
  nodejs,
  pnpm_9,
  cacert,
  valkey,
  dataDir ? "/var/lib/zammad",
}:

let
  pname = "zammad";
  version = "6.5.2";

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
    name = "zammad-gems-${version}";
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
    valkey
    postgresql
    pnpm_9.configHook
    nodejs
    procps
    cacert
  ];

  env.RAILS_ENV = "production";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname src;

    fetcherVersion = 1;
    hash = "sha256-mfdzb/LXQYL8kaQpWi9wD3OOroOOonDlJrhy9Dwl1no";
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
    # dataDir will be set in the module, and the package gets overridden there
    ln -s ${dataDir}/config/database.yml $out/config/database.yml
    ln -s ${dataDir}/config/secrets.yml $out/config/secrets.yml
    ln -s ${dataDir}/log $out/log
    ln -s ${dataDir}/storage $out/storage
    ln -s ${dataDir}/tmp $out/tmp
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

  meta = {
    description = "Web-based, open source user support/ticketing solution";
    homepage = "https://zammad.org";
    license = lib.licenses.agpl3Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      taeer
      netali
    ];
  };
}
