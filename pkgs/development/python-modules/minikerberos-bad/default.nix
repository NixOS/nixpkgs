{
  lib,
  asn1crypto,
  asysocks,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  fetchPypi,
  oscrypto,
  pythonOlder,
  setuptools,
  six,
  tqdm,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "minikerberos-bad";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "minikerberos-bAD";
    tag = version;
    hash = "sha256-pnIn7UOpnCke6voFvOwcONXDd9i/di1lE/57vkg0/0w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    cryptography
    asysocks
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
    homepage = "https://github.com/CravateRouge/minikerberos-bAD";
    changelog = "https://github.com/CravateRouge/minikerberos-bAD/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
