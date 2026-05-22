{
  lib,
  fetchFromGitHub,
  buildGoModule,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "vi-mongo";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "kopecmaciej";
    repo = "vi-mongo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0TMrQ1dbAP7HOjrVVcnoHPchf7e14Qzcl5lAD0rHTDs=";
  };

  vendorHash = "sha256-CuFoH6crS6BOsSj2hNGw7loi4RixHbyJGySfxglUUmg=";

  ldflags = [
    "-s"
    "-X=github.com/kopecmaciej/vi-mongo/internal/build.Version=${finalAttrs.version}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MongoDB TUI manager designed to simplify data visualization and quick manipulation";
    homepage = "https://github.com/kopecmaciej/vi-mongo";
    changelog = "https://github.com/kopecmaciej/vi-mongo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "vi-mongo";
  };
})
