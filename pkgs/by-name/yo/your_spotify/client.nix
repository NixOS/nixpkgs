{
  stdenv,
  src,
  version,
  meta,
  offlineCache,
  apiEndpoint ? "http://localhost:3000",
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "your_spotify_client";
  inherit version src offlineCache;

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  API_ENDPOINT = "${apiEndpoint}";
  preBuild = ''
    pushd ./apps/client/
  '';
  postBuild = ''
    substituteInPlace scripts/run/variables.sh --replace-quiet '/app/apps/client/' "./"
    chmod +x ./scripts/run/variables.sh
    patchShebangs --build ./scripts/run/variables.sh
    ./scripts/run/variables.sh
    popd
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r ./apps/client/build/* $out
    runHook postInstall
  '';

  inherit meta;
})
