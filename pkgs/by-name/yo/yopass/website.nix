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
    hash = "sha256-vUcCKdySGoHqf5khSUGP/jN0YPmPwRg9EOJa77dk1L0=";
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
