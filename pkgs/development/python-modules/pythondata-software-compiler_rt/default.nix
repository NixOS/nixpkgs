{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
buildPythonPackage rec {
  pname = "pythondata-software-compiler_rt";
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "pythondata-software-compiler_rt";
    tag = version;
    hash = "sha256-s/tfxhPwYAnu1z1LxEimeYWjX6IHbF2uD/1HjvQn/xo=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
  ];

  meta = {
    description = "Python module containing data files for compiler_rt software (for use with LiteX)";
    homepage = "https://github.com/litex-hub/pythondata-software-compiler_rt";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ RossComputerGuy ];
  };
}
