{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  migen,
  pyserial,
  requests,
}:
buildPythonPackage rec {
  pname = "litex";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enjoy-digital";
    repo = "litex";
    tag = version;
    hash = "sha256-KtIKB6FAqVKjZXLNG9uV8QjLJqDI3qT2x0XXnE+3aRs=";
  };

  patches = [
    ./fix-impure.patch
    ./fix-toolchain.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    migen
    pyserial
    requests
  ];

  meta = {
    description = "Provides a convenient and efficient infrastructure to create FPGA Cores/SoCs";
    homepage = "https://github.com/enjoy-digital/litex";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
