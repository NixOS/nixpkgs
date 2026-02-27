{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  litex,
}:
buildPythonPackage rec {
  pname = "litedram";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "litedram";
    tag = version;
    hash = "sha256-aN1QPR/5rg9kTmtTtvXDfbYCPd7mzH4SLXxzdnktR0A=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
    litex
  ];

  meta = {
    description = "Small footprint and configurable DRAM core";
    homepage = "https://github.com/enjoy-digital/litedram";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
