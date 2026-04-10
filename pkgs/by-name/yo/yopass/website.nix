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
    hash = "sha256-/SHl/U/iVdzF+PojOFdO3z/yX4uuts438DKQcycn8Ik=";
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
