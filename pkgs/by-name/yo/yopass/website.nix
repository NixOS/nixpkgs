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
    hash = "sha256-uNtQCAu2LtE8O7AjGaXnlKsHxc5nX2AxEb+3awyNBOA=";
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
