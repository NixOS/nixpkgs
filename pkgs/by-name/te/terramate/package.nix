{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule rec {
  pname = "terramate";
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${version}";
    hash = "sha256-SS+N/jwI7im906HJiUKcq3Ac1epHkP7186ihbndsHSw=";
  };

  vendorHash = "sha256-qM6BeCCf60VJhhHKDoHahqQfXH4VZjP8QdfGcF2egaA=";

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
    changelog = "https://github.com/terramate-io/terramate/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      dit7ya
      asininemonkey
    ];
  };
}
