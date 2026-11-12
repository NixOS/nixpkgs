{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "yet-another-cloudwatch-exporter";
  version = "0.68.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "yet-another-cloudwatch-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IV39nzS1eit6L0GPzK8MtNek28CVEtm9iuDpOPOJRsI=";
  };

  vendorHash = "sha256-t7UKznhmbDkO5CNxekitE4HtWEhW3Oe/VK/Tl1wy9fc=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/prometheus/common/version.Version=${finalAttrs.version}"
    "-X github.com/prometheus/common/version.Branch=master"
    "-X github.com/prometheus/common/version.BuildUser=nixbld@nixpkgs"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prometheus exporter for AWS CloudWatch metrics";
    homepage = "https://github.com/prometheus-community/yet-another-cloudwatch-exporter";
    changelog = "https://github.com/prometheus-community/yet-another-cloudwatch-exporter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rhousand ];
    mainProgram = "yace";
  };
})
