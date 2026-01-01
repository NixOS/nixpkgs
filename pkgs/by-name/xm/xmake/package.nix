{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmake";
<<<<<<< HEAD
  version = "3.0.5";
=======
  version = "3.0.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "xmake-io";
    repo = "xmake";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-rmChbjWRFL2vchifupLBraalMHYze035xjLNLCYzwm8=";
=======
    hash = "sha256-0Hh7XqKAt0yrg1GejEZmKpY3c8EvK7Z2eBS8GNaxYlg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/xmake-io/xmake/releases/tag/v${finalAttrs.version}";
    description = "Cross-platform build utility based on Lua";
    homepage = "https://xmake.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      wineee
      rennsax
    ];
    mainProgram = "xmake";
  };
})
