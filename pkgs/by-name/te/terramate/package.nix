{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule rec {
  pname = "terramate";
  version = "0.14.6";

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${version}";
    hash = "sha256-fDAd98TgS9f6094rn32EOONVbjgoW+KIN0U2LMjzcm8=";
  };

  vendorHash = "sha256-uS/4lDFd13U7oOct4JeSIc3WNqkB1x/clPf0A16Za/s=";

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
