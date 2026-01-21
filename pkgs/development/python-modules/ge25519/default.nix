{
  lib,
  bitlist,
  buildPythonPackage,
  fe25519,
  fetchPypi,
  fountains,
  parts,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ge25519";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eqduw1nMHMiMIvhzXA1Zg2foqQscQwFLhgm9aJYvmuo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fe25519
    parts
    bitlist
    fountains
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ge25519" ];

  meta = {
    description = "Python implementation of Ed25519 group elements and operations";
    homepage = "https://github.com/nthparty/ge25519";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
