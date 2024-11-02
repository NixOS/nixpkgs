{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  unicrypto,
  asyauth,
  asysocks,
  asn1crypto,
  winacl,
  prompt-toolkit,
  tqdm,
  wcwidth,
  tabulate,
}:

buildPythonPackage rec {
  pname = "msldap";
  version = "0.5.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RKKj0oUPkl5QtrgtRRXHTO6lSLfB/E09DT9t9loMxUA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    unicrypto
    asyauth
    asysocks
    asn1crypto
    winacl
    prompt-toolkit
    tqdm
    wcwidth
    tabulate
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "msldap" ];

  meta = with lib; {
    description = "Python LDAP library for auditing MS AD";
    homepage = "https://github.com/skelsec/msldap";
    changelog = "https://github.com/skelsec/msldap/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
