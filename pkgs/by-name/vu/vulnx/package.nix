{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "vulnx";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "vulnx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HejAK/KXpQ9HouA3JpX7MoMzMUoMmKX7eEKwMGfgSx4=";
  };

  vendorHash = "sha256-WVskArdIieEof/GDlzEZbY4QDYfAQyP0+Le24q+Kfu0=";

  subPackages = [ "cmd/vulnx/" ];

  ldflags = [ "-s" ];

  __structuredAttrs = true;

  strictDeps = true;

  # Issue with updater and version check
  # nativeInstallCheckInputs = [ versionCheckHook ];
  # doInstallCheck = true;
  # versionCheckProgramArg = [ "version" ];

  meta = {
    description = "Tool to work with CVEs";
    homepage = "https://github.com/projectdiscovery/vulnx";
    changelog = "https://github.com/projectdiscovery/vulnx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "vulnx";
  };
})
