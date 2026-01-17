{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
buildPythonPackage rec {
  pname = "pythondata-software-picolibc";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "pythondata-software-picolibc";
    tag = version;
    hash = "sha256-0OpEdBGu/tkFFPUi1RLsTqF2tKwLSfYIi+vPqgfLMd8=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
  ];

  meta = {
    description = "Python module containing data files for picolibc software (for use with LiteX)";
    homepage = "https://github.com/litex-hub/pythondata-software-picolibc";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
