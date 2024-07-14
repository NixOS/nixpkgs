{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "lml";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V6CFopu3mR1w1BxsMUTFYKjjW0wQMP+zbYX6BYdzvMU=";
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
    maintainers = with lib.maintainers; [ ];
  };
}
