{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fonttools,
  black,
}:

buildPythonPackage rec {
  pname = "paintcompiler";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simoncozens";
    repo = "paintcompiler";
    rev = "v${version}";
    hash = "sha256-dmVBQUUyFc71zq8fXBQ4ii/llrGdtUCOponCzSeut6g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fonttools
    black
  ];

  pythonImportsCheck = [
    "paintcompiler"
    "paintdecompiler"
  ];

  meta = {
    description = "Paint compiler for COLRv1 fonts";
    homepage = "https://github.com/simoncozens/paintcompiler";
    license = lib.licenses.asl20;
    mainProgram = "paintcompiler";
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
