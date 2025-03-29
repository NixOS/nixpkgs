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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ge25519";
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VKDPiSdufWwrNcZSRTByFU4YGoJrm48TDm1nt4VyclA=";
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

  meta = with lib; {
    description = "Python implementation of Ed25519 group elements and operations";
    homepage = "https://github.com/nthparty/ge25519";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
