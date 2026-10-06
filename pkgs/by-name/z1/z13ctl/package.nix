{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "z13ctl";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "dahui";
    repo = "z13ctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oHGZS45ciompNiSWqP1yS4WnKV47QrO7lBQS4cLwgDs=";
  };

  vendorHash = "sha256-KtH7NnJczELuDXCQK7VnI1Cg7if9USxyuADEuYhETwk=";

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
