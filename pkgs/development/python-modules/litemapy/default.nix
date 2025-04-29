{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  nbtlib,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "litemapy";
  version = "0.10.0b0";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "SmylerMC";
    repo = "litemapy";
    rev = "v${version}";
    hash = "sha256-mGRnrFfrg0VD9pXs0WOuiP6QnYyu0Jbv/bqCWtkOie0=";
  };

  propagatedBuildInputs = [
    nbtlib
    typing-extensions
  ];

  pythonImportsCheck = [ "litemapy" ];

  meta = with lib; {
    description = "Python library to read and edit Litematica's schematic file format";
    homepage = "https://github.com/SmylerMC/litemapy";
    changelog = "https://github.com/SmylerMC/litemapy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gdd ];
  };
}
