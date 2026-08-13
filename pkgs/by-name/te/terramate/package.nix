{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "terramate";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "terramate-io";
    repo = "terramate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NoQLxvby0sUA/tcyfJUMuNQukfQINS+v1oJDS0+ehJ0=";
  };

  vendorHash = "sha256-vmweLyq9lr2V4ou2mzVnIaI8p63D9c0IVLKo8vYLm54=";

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
