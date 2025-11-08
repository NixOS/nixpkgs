{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tocaia";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "manipuladordedados";
    repo = "tocaia";
    tag = finalAttrs.version;
    hash = "sha256-Np+Awn5KGoAbeoUEkcAeVwnNCqI2Iy+19Zj1RkNfgXU=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Portable TUI Gopher client written in C89 for POSIX systems";
    homepage = "https://github.com/manipuladordedados/tocaia";
    changelog = "https://github.com/manipuladordedados/tocaia/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ manipuladordedados ];
    mainProgram = "tocaia";
  };
})
