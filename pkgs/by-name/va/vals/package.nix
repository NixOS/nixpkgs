{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  vals,
}:

buildGoModule (finalAttrs: {
  pname = "vals";
  version = "0.44.5";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "helmfile";
    repo = "vals";
    sha256 = "sha256-VrS0+FkwOtpoz5kjpNpOYlGL+Mfw/wvSiMbvHx+0UYM=";
  };

  vendorHash = "sha256-o6+W+qIbfmeLh7N3eFftdVS6aNUUSPa+hbxYeGuq23E=";

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  # Tests require connectivity to various backends.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = vals;
    command = "vals version";
  };

  meta = {
    description = "Helm-like configuration values loader with support for various sources";
    mainProgram = "vals";
    license = lib.licenses.asl20;
    homepage = "https://github.com/helmfile/vals";
    changelog = "https://github.com/helmfile/vals/releases/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ stehessel ];
  };
})
