{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule rec {
  pname = "terramate";
<<<<<<< HEAD
  version = "0.15.2";
=======
  version = "0.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-NPMcAVv994KGkKUGeqSuuwRQThcYkmojKbUSy5G+lq4=";
=======
    hash = "sha256-JI5NwohnSFogOgzk7PJplFhXNnhfrkOk6U/7bWPtGVk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-o2MNmJmYMq2mQBLslOtRyRH9euEhcJyIhohJ3CKp6kg=";

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
