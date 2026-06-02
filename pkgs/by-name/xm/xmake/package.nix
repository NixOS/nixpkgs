{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmake";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "xmake-io";
    repo = "xmake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Rm1OtjpyzM/G8YN8nsK8TypF/C/8tQvW+7TxEX5st0=";
    fetchSubmodules = true;
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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
