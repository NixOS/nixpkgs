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

  missingHashes = ./missing-hashes.json;
  yarnOfflineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-FbKaU3wezuvcn98FOcUZbmoot/iHtmeStp4n0dNwFYA=";
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
