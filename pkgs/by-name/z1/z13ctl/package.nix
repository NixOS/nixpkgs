{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "z13ctl";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "dahui";
    repo = "z13ctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U7bQygIzUzca5eC5PUpWIQBeHdi1WjB0un+dGkqBmM8=";
  };

  vendorHash = "sha256-MmTbodDm6g8HFWOF4ziOUJkk7T0WIy3ZldYQFMX+ID0=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dahui/z13ctl/cmd.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Utility for ASUS ROG Flow Z13 (2025)";
    homepage = "https://github.com/dahui/z13ctl";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "z13ctl";
    maintainers = with lib.maintainers; [ badheuristic ];
  };
})
