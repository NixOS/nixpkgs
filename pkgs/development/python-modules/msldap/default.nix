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
  version = "0.5.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zb/g5QLJTSb0XTZvVnzbYkYvJ/ZVvQri8CKP48n5ibg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
