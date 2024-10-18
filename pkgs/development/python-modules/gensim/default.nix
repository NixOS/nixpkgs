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

  disabled = pythonOlder "3.8";

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

  pythonImportsCheck = [ "gensim" ];

  # Test setup takes several minutes
  doCheck = false;

  pytestFlagsArray = [ "gensim/test" ];

  meta = with lib; {
    description = "Topic-modelling library";
    homepage = "https://radimrehurek.com/gensim/";
    changelog = "https://github.com/RaRe-Technologies/gensim/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ jyp ];
  };
}
