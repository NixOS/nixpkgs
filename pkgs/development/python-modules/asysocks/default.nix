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
  version = "0.2.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RBhbLEceY7cpMXOWfu87D15g7VzBt2UKMKlWnkn/Jfg=";
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
