{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "yet-another-cloudwatch-exporter";
  version = "0.67.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "prometheus-community";
    repo = "yet-another-cloudwatch-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3VMNLkzzwJX4ZhLihppjyBZDD/W+z5xLsMkZLUYHOF0=";
  };

  vendorHash = "sha256-0wHvXiYQGYU89SSOEBxiSC0CLGwOfN2Dzn8WeEBLYFk=";

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
