{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  vals,
}:

buildGoModule rec {
  pname = "vals";
  version = "0.42.5";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "helmfile";
    repo = "vals";
    sha256 = "sha256-rCy2fEg/qAnieW8ptK8Zw6S2V5PzxQ27NUXig+lDvuQ=";
  };

  vendorHash = "sha256-PTw9l9/IZjkgyDd5m9DfN1L8PEFvqaBltyclX9BZ+98=";

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
