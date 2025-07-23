{
  stdenv,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  version,
  src,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "locust-ui";
  inherit version src;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-OTGTpAAxr8rmCi5oEWIWzwZqiP3Cx3vyc3r2kbcLyUg=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  dontNpmPrune = true;
  yarnBuildScript = "build";
  postInstall = ''
    mkdir -p $out/dist
    cp -r dist/** $out/dist
  '';
})
