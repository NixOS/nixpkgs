{
  lib,
  buildPythonPackage,
  cython_0,
  oldest-supported-numpy,
  setuptools,
  fetchPypi,
  mock,
  numpy,
  scipy,
  smart-open,
  pyemd,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gensim";
  version = "4.3.3";
  pyproject = true;

  # C code generated with CPython3.12 does not work cython_0.
  disabled = !(pythonOlder "3.12");

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hIUgdqaj2I19rFviReJMIcO4GbVl4UwbYfo+Xudtz1c=";
  };

  build-system = [
    cython_0
    oldest-supported-numpy
    setuptools
  ];

  dependencies = [
    smart-open
    numpy
    scipy
  ];

  nativeCheckInputs = [
    mock
    pyemd
    pytestCheckHook
  ];

  pythonRelaxDeps = [
    "scipy"
  ];

  pythonImportsCheck = [ "gensim" ];

  # Test setup takes several minutes
  doCheck = false;

  enabledTestPaths = [ "gensim/test" ];

  meta = with lib; {
    description = "Topic-modelling library";
    homepage = "https://radimrehurek.com/gensim/";
    changelog = "https://github.com/RaRe-Technologies/gensim/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
  };
}
