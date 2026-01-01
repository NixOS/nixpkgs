{
  lib,
  bitlist,
  buildPythonPackage,
  fetchPypi,
  fountains,
  parts,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fe25519";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kf5OCTG3IL2dYGvzFngoS+OMZPqq/O//8Gf0a2McgPc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bitlist
    fountains
    parts
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fe25519" ];

<<<<<<< HEAD
  meta = {
    description = "Python field operations for Curve25519's prime";
    homepage = "https://github.com/BjoernMHaase/fe25519";
    license = with lib.licenses; [ cc0 ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python field operations for Curve25519's prime";
    homepage = "https://github.com/BjoernMHaase/fe25519";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
