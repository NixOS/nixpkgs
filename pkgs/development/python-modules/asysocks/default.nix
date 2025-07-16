{
  lib,
  asn1crypto,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  h11,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asysocks";
  version = "0.2.17";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r6F7Sel8D3noBQE8fDYQ5k9NzIFOmUWT+1CGrWVCWTw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    cryptography
    h11
  ];

  # Upstream hasn't release the tests yet
  doCheck = false;

  pythonImportsCheck = [ "asysocks" ];

  meta = with lib; {
    description = "Python Socks4/5 client and server library";
    homepage = "https://github.com/skelsec/asysocks";
    changelog = "https://github.com/skelsec/asysocks/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
