{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "priority";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c965d54f1b8d0d0b19479db3924c7c36cf672dbf2aec92d43fbdaf4492ba18c0";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "priority" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  meta = {
    description = "Pure-Python implementation of the HTTP/2 priority tree";
    homepage = "https://github.com/python-hyper/priority/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qyliss ];
  };
}
