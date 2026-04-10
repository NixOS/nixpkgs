{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  version = "0.5.15";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uAJKLAVZFY7EB8tjFyAezINicki6ruzuXf1EGcp3Pj0=";
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

  meta = {
    description = "Python LDAP library for auditing MS AD";
    homepage = "https://github.com/skelsec/msldap";
    changelog = "https://github.com/skelsec/msldap/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
