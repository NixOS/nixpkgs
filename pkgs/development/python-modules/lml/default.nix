{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "lml";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jdWvtDZ6WT0c2yFEoFh0zZk49SZr67DJ4UEyAEI8DXQ=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  # Tests broken.
  doCheck = false;

  meta = {
    description = "Load me later. A lazy plugin management system for Python";
    homepage = "http://lml.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
