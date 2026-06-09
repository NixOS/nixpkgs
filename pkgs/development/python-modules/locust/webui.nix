{
  stdenv,
  yarn-berry_4,
  nodejs,
  version,
  src,
  lib,
}:
let
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "locust-ui";
  inherit version src;

  patches = [
    # Remove after upstream updates to Yarn 4.14
    # https://github.com/locustio/locust/blob/master/locust/webui/package.json#L89
    ./yarn-4.14-support.patch
  ];

  missingHashes = ./missing-hashes.json;
  yarnOfflineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes patches;
    hash = "sha256-4iRQYw1MrIoY0h939h86F2AROKxpfIXSqr/m0IYS3Jg=";
  };

  nativeBuildInputs = [
    yarn-berry
    yarn-berry.yarnBerryConfigHook
    nodejs
  ];

  buildPhase = ''
    runHook preBuild
    yarn build
    runHook postBuild
  '';

  dontNpmPrune = true;
  postInstall = ''
    mkdir -p $out/dist
    cp -r dist/** $out/dist
  '';
})
