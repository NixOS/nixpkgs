{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  vals,
}:

buildGoModule rec {
  pname = "vals";
  version = "0.43.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "helmfile";
    repo = "vals";
    sha256 = "sha256-uY4xu778DaX69sPcOCYAe3H/zSq4B0KdHETyDQ2hvzs=";
  };

  vendorHash = "sha256-I2xHYyAurUegN22Ry9oTi6tKFgTTdNHfiqTeBX1N83Q=";

  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
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
    changelog = "https://github.com/helmfile/vals/releases/v${version}";
    maintainers = with lib.maintainers; [ stehessel ];
  };
}
