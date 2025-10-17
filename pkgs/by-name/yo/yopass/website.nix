{
  fetchYarnDeps,
  nodejs-slim,
  src,
  stdenv,
  version,
  yarnBuildHook,
  yarnConfigHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yopass-website";
  inherit version;

  src = src + "/website";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-p84Yors8AClUP3wL4riVY9zjFvZyo9QkUws4rvYbhik=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs-slim
  ];

  installPhase = ''
    runHook preInstall

    mv dist $out

    runHook postInstall
  '';
})
