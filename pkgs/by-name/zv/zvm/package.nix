{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "zvm";
  version = "0.8.20";

  src = fetchFromGitHub {
    owner = "tristanisham";
    repo = "zvm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gZtdlKNu0NcSzf9P4eSJ3hcgU+aaDtBTrvBhWimQIUc=";
  };

  vendorHash = "sha256-G9Ba9eqa8cGs0UiEb2guJ4J2yGWR8npb9V+yP/kl4HU=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.zvm.app/";
    downloadPage = "https://github.com/tristanisham/zvm";
    changelog = "https://github.com/tristanisham/zvm/releases/tag/v${finalAttrs.version}";
    description = "Tool to manage and use different Zig versions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.unix;
    mainProgram = "zvm";
  };
})
