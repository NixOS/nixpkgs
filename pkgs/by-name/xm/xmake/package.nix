{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmake";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "xmake-io";
    repo = "xmake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GZ296Bn+jtJKPaqVLpyDgiYwrej8CDHIudkqNJ3KUfA=";
    fetchSubmodules = true;
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

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
