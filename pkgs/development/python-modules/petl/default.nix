{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "petl";
  version = "1.7.15";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jjFDg4CtUVUlOYZa07GrZV3htTG9A5gMhx7Cz/SoxBQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "petl"
  ];

  meta = {
    homepage = "https://github.com/petl-developers/petl";
    description = "Python Extract Transform and Load Tables of Data";
    longDescription = ''
      A general purpose Python package for extracting, transforming and loading
      tables of data.
    '';
    license = lib.licenses.mit;
    mainProgram = "petl";
  };
}
