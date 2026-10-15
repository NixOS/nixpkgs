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

buildPythonPackage {
  pname = "kerbad";
  version = "0.5.6-unstable-2025-10-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "kerbad";
    rev = "3c2284de4d2390e22026b550705622ed39e5c05a"; # no tag available
    hash = "sha256-V4KaF6lsECoLVpGZTZ4p7q9drHSsrsLPI/9zEQpqm3I=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
