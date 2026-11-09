{
  stdenv,
  yarn-berry,
  nodejs,
  version,
  src,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "locust-ui";
  inherit version src;

  missingHashes = ./missing-hashes.json;
  yarnOfflineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-68qt7SLeY2r5s1LnNqYCR56KjdH4Y93T+NlTet7oMR8=";
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
