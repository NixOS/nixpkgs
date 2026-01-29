{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  litex,
}:
buildPythonPackage rec {
  pname = "liteiclink";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "liteiclink";
    tag = version;
    hash = "sha256-hniCGn4+akpEEFcK84H4pxwX8M+Ku/O7MDK8L670aSs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
    litex
  ];

  meta = {
    description = "Small footprint and configurable Inter-Chip communication cores";
    homepage = "https://github.com/enjoy-digital/liteiclink";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
