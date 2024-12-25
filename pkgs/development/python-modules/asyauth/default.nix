{
  lib,
  asn1crypto,
  asysocks,
  buildPythonPackage,
  fetchPypi,
  minikerberos,
  pythonOlder,
  setuptools,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "asyauth";
  version = "0.0.21";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NMwQxfhij/LiW1EW3JjvxcpFUy8WPM0/kUej4C3YEOs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    asysocks
    minikerberos
    unicrypto
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "asyauth" ];

  meta = with lib; {
    description = "Unified authentication library";
    homepage = "https://github.com/skelsec/asyauth";
    changelog = "https://github.com/skelsec/asyauth/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
