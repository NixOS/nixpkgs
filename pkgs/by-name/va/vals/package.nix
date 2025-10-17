{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  vals,
}:

buildGoModule rec {
  pname = "vals";
  version = "0.42.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "helmfile";
    repo = "vals";
    sha256 = "sha256-NdK7toICK9NJ6H8trCYJCEFE0weYH1Ban7dSlG1SM/c=";
  };

  vendorHash = "sha256-FjTxef9LHQopxiJYJFcAWcGJk5byVcEBlQFUssbfYwY=";

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
