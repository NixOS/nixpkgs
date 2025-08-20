{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "zvm";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "tristanisham";
    repo = "zvm";
    tag = "v${version}";
    hash = "sha256-M1xpE2Lq6XZgvH9J0c2Xj1BJNN+4TTGwp4iluVyVAJs=";
  };

  vendorHash = "sha256-wo+vA9AYXIjv6SGb7hNY6ZIVMyJ5enMd8gpQ6u3F7To=";

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
