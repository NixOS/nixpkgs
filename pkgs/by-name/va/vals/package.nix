{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  vals,
}:

buildGoModule rec {
  pname = "vals";
  version = "0.38.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "helmfile";
    repo = pname;
    sha256 = "sha256-dN4712rZ/nElYpthW+27WSFOeNmV2Bm7Zx/OEIrKwsQ=";
  };

  vendorHash = "sha256-EihgFqD80YlFaEJfeS2C91ifk7yYhZQcgEUteIk3siM=";

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

  meta = with lib; {
    description = "Helm-like configuration values loader with support for various sources";
    mainProgram = "vals";
    license = licenses.asl20;
    homepage = "https://github.com/helmfile/vals";
    changelog = "https://github.com/helmfile/vals/releases/v${version}";
    maintainers = with maintainers; [ stehessel ];
  };
}
