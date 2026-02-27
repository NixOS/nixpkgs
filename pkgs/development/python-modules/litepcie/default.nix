{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  litex,
}:
buildPythonPackage rec {
  pname = "litepcie";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "litepcie";
    tag = version;
    hash = "sha256-Wi/gV7NmLOu8rLNWn4kECcB6gfdlOjOJQy64dwx0Dks=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
    litex
  ];

  meta = {
    description = "Small footprint and configurable PCIe core";
    homepage = "https://github.com/enjoy-digital/litepcie";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
