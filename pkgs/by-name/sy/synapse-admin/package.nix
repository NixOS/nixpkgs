{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  yarn-berry,
  cacert,
  nix-update-script,
  formats,
  baseUrl ? null,
}:

let
  config = lib.optionalAttrs (baseUrl != null) { restrictBaseUrl = baseUrl; };
  configFormat = formats.json { };
  configFile = configFormat.generate "synapse-admin-config" config;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "synapse-admin";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "Awesome-Technologies";
    repo = "synapse-admin";
    tag = finalAttrs.version;
    hash = "sha256-rK1Tc1K3wx6/1J8TEw5Lb9g09gbt/1HoZdDrEFzxTQQ=";
  };

  # we cannot use fetchYarnDeps because that doesn't support yarn 2/berry lockfiles
  yarnOfflineCache = stdenv.mkDerivation {
    pname = "yarn-deps";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [ yarn-berry ];

    dontInstall = true;

    env = {
      YARN_ENABLE_TELEMETRY = 0;
      NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    };

    supportedArchitectures = builtins.toJSON {
      os = [
        "darwin"
        "linux"
      ];
      cpu = [
        "arm"
        "arm64"
        "ia32"
        "x64"
      ];
      libc = [
        "glibc"
        "musl"
      ];
    };

    configurePhase = ''
      runHook preConfigure

      export HOME="$NIX_BUILD_TOP"
      yarn config set enableGlobalCache false
      yarn config set cacheFolder $out
      yarn config set --json supportedArchitectures "$supportedArchitectures"

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      mkdir -p $out
      yarn install --immutable --mode skip-build

      runHook postBuild
    '';

    outputHash = "sha256-IiViodAB1KAYsRRr8+zw3vrCbUYp7Mdtazi0Y6SEFNU=";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry
  ];

  env = {
    NODE_ENV = "production";
  };

  postPatch = ''
    substituteInPlace vite.config.ts \
      --replace-fail "git describe --tags" "echo ${finalAttrs.version}"
  '';

  configurePhase = ''
    runHook preConfigure

    export HOME="$NIX_BUILD_TOP"
    yarn config set enableGlobalCache false
    yarn config set cacheFolder $yarnOfflineCache

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn install --immutable --immutable-cache
    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    cp ${configFile} $out/config.json

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Admin UI for Synapse Homeservers";
    homepage = "https://github.com/Awesome-Technologies/synapse-admin";
    changelog = "https://github.com/Awesome-Technologies/synapse-admin/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      mkg20001
      ma27
    ];
  };
})
