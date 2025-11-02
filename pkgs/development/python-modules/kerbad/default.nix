{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  asn1crypto,
  asysocks,
  cryptography,
  dnspython,
  minikerberos,
  oscrypto,
  six,
  tqdm,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "kerbad";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "kerbad";
    tag = version;
    hash = "sha256-pnIn7UOpnCke6voFvOwcONXDd9i/di1lE/57vkg0/0w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    asysocks
    cryptography
    dnspython
    minikerberos
    oscrypto
    six
    tqdm
    unicrypto
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "minikerberos" ];

  meta = {
    description = "Kerberos manipulation library in pure Python";
    homepage = "https://github.com/CravateRouge/kerbad";
    changelog = "https://github.com/CravateRouge/kerbad/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
