{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "terramate";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jdhOuaSFcq3bw9cX+IJN233x4o76shMfZQDmyUiTWO4=";
  };

  vendorHash = "sha256-tjAsA8rxFE4zINc0Dpm2/5PpJ6BGYJiz059dBKCKsck=";

  # required for version info
  nativeBuildInputs = [ git ];

  ldflags = [
    "-extldflags"
    "-static"
  ];

  # Needed for the tests to pass on macOS
  __darwinAllowLocalNetworking = true;

  # Disable failing E2E tests preventing the package from building
  excludedPackages = [
    "./e2etests/cloud"
    "./e2etests/core"
  ];

  meta = {
    description = "Adds code generation, stacks, orchestration, change detection, data sharing and more to Terraform";
    homepage = "https://github.com/terramate-io/terramate";
    changelog = "https://github.com/terramate-io/terramate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      asininemonkey
    ];
  };
})
