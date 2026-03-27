{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGo126Module rec {
  pname = "zvm";
  version = "0.8.14";

  src = fetchFromGitHub {
    owner = "tristanisham";
    repo = "zvm";
    tag = "v${version}";
    hash = "sha256-MAE7zs60DFIicYRtMhstzsOiS2flVv+dyPJVmcyAEio=";
  };

  vendorHash = "sha256-29hFuQnLPdLkAG4x5QWqXqBIGtppi/rj3OuTfMBgTAI=";

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.zvm.app/";
    downloadPage = "https://github.com/tristanisham/zvm";
    changelog = "https://github.com/tristanisham/zvm/releases/tag/v${version}";
    description = "Tool to manage and use different Zig versions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.unix;
    mainProgram = "zvm";
  };
}
