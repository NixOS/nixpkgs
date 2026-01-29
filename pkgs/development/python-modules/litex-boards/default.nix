{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  litedram,
  liteeth,
  litepcie,
  litesdcard,
  litex,
  pythondata-cpu-vexriscv_smp,
}:
buildPythonPackage rec {
  pname = "litex-boards";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "litex-boards";
    tag = version;
    hash = "sha256-7ffLnBuc5nds/IB3mGjIhetwQjibjOB53w8BG6e+5+s=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    litex
    litedram
    liteeth
    litepcie
    litesdcard
    pythondata-cpu-vexriscv_smp
  ];

  meta = {
    description = "LiteX boards files";
    homepage = "https://github.com/litex-hub/litex-boards";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
