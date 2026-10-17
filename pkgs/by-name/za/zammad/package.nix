{
  stdenvNoCC,
  lib,
  nixosTests,
  fetchFromGitHub,
  fetchpatch,
  applyPatches,
  bundlerEnv,
  callPackage,
  procps,
  ruby,
  postgresql,
  jq,
  moreutils,
  nodejs,
  pnpm_10_latest,
  fetchPnpmDeps,
  pnpmConfigHook,
  cacert,
  valkey,
  dataDir ? "/var/lib/zammad",
}:

let
  pname = "zammad";
  version = "7.1.3";

  src = applyPatches {
    src = fetchFromGitHub (lib.importJSON ./source.json);
    patches = [
      ./fix-sendmail-location.diff
    ];

    postPatch = ''
      sed -i -e "s|ruby '3.4.[0-9]\+'|ruby '${ruby.version}'|" Gemfile
      sed -i -e "s|ruby 3.4.[0-9]\+p[0-9]\+|ruby ${ruby.version}|" Gemfile.lock
      sed -i -e "s|3.4.[0-9]\+|${ruby.version}|" .ruby-version
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
    pnpmConfigHook
    pnpm_10_latest
    nodejs
    procps
    cacert
  ];

  env.RAILS_ENV = "production";

  pnpmDeps = fetchPnpmDeps {
    inherit pname src;
    pnpm = pnpm_10_latest;

    fetcherVersion = 3;
    hash = "sha256-JG1VhG56L1bDyrVOjP4MFB5h//dVchgnrHiqhGNIuw4=";
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
    changelog = "https://zammad.com/en/product/releases/${lib.replaceString "." "-" version}";
    description = "Web-based, open source user support/ticketing solution";
    homepage = "https://zammad.org";
    license = lib.licenses.agpl3Plus;
    knownVulnerabilities = [
      "Zammad 7.1.3 is affected by several vulnerabilities, fixed in the newer version 7.2.2 that is available in nixos-unstable and won't be backported."
      "GHSA-79wh-8g2f-xj2c"
      "GHSA-f3qr-94c2-7mx2"
      "GHSA-gvvq-mfj3-g56x"
      "GHSA-852x-r9wm-4v5j"
      "GHSA-fhq9-h46w-68hg"
      "GHSA-g9f6-7w7h-99f7"
      "GHSA-7622-vcx5-885g"
      "GHSA-23hj-h8w6-rgm3"
      "GHSA-qvmq-j8hm-2mmc"
      "GHSA-h5pm-rjvp-fr47"
      "GHSA-x777-frqf-7w45"
      "GHSA-jhhg-q69j-35wq"
      "GHSA-fqh9-pvgg-jgpw"
      "GHSA-f8x4-5mjf-mc32"
      "GHSA-xq4h-fjvm-m7x4"
      "GHSA-8rr9-v56q-rcq9"
      "GHSA-87pp-7pxh-xfcg"
      "GHSA-hrpc-pjjc-v9vg"
      "GHSA-x3fm-p95w-xj7v"
      "GHSA-r4xq-6xg5-72p7"
      "GHSA-jr3g-8mch-9vrf"
      "GHSA-hpwv-2cr4-rqpf"
      "GHSA-8xp6-vq6v-xrfj"
      "GHSA-mf8g-36j9-x25g"
      "GHSA-32f8-x62f-599m"
      "GHSA-5qm6-wgv7-2344"
      "GHSA-4r9g-r4wx-44p6"
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      taeer
      netali
      meenzen
    ];
  };
}
