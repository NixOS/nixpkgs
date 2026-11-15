{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "yardstick";
  version = "0.17.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "anchore";
    repo = "yardstick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7YCR1cVW9YRjA4BSkCRiIZb/iy2upi+BhHG7EwnrrG8=";
  };

  vendorHash = "sha256-y0U/H6Grk2s2+Sb/5lRTgv8a2Ttnqo2eEKISB+eF4K0=";

  subPackages = [ "cmd/yardstick" ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.gitCommit=${finalAttrs.src.rev}"
    "-X=main.buildDate=1970-01-01T00:00:00Z"
    "-X=main.gitDescription=${finalAttrs.src.rev}"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to compare vulnerability scanners results";
    homepage = "https://github.com/anchore/yardstick";
    changelog = "https://github.com/anchore/yardstick/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "yardstick";
  };
})
