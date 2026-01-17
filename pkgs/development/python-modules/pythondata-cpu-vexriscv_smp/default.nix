{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
buildPythonPackage rec {
  pname = "pythondata-cpu-vexriscv_smp";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "pythondata-cpu-vexriscv_smp";
    tag = version;
    hash = "sha256-ZigxOPTelx96hCw3t5TASgvxgMjJvOqLAiPHXhe0sXc=";
    fetchSubmodules = true;
  };

  patches = [
    ./fix-git.patch
  ];

  build-system = [
    setuptools
  ];

  meta = {
    description = "Small footprint and configurable DRAM core";
    homepage = "https://github.com/litex-hub/pythondata-cpu-vexriscv_smp";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
