{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  vals,
}:

buildGoModule (finalAttrs: {
  pname = "vals";
  version = "0.44.0";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "helmfile";
    repo = "vals";
    sha256 = "sha256-t13qzIE1nl+AjxdFISD61ScahWuFJV7ROqtSr22Tscs=";
  };

  vendorHash = "sha256-xBOac8rDMsn+gX5QWdIoP9BdqBmdZ7tvtRG677uiCpM=";

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
