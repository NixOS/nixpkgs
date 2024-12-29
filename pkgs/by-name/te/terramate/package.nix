{ lib
, buildGoModule
, fetchFromGitHub
, git
}:

buildGoModule rec {
  pname = "terramate";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${version}";
    hash = "sha256-xEV72bswFW7ie3FWa07vmffIXMIi0A5ZSpg6wRS7o5g=";
  };

  vendorHash = "sha256-6nnUyNOdG1QmaHeRXRWvyjLhYPXA3Xs9062ZkF82Kzo=";

  # required for version info
  nativeBuildInputs = [ git ];

  ldflags = [ "-extldflags" "-static" ];

  # Disable failing E2E tests preventing the package from building
  excludedPackages = [ "./e2etests/cloud" "./e2etests/core" ];

  meta = with lib; {
    description = "Adds code generation, stacks, orchestration, change detection, data sharing and more to Terraform";
    homepage = "https://github.com/terramate-io/terramate";
    changelog = "https://github.com/terramate-io/terramate/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya asininemonkey ];
  };
}
