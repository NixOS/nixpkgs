{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  asn1crypto,
  asysocks,
  badauth,
  kerbad,
  prompt-toolkit,
  tabulate,
  tqdm,
  unicrypto,
  unidns,
  wcwidth,
  winacl,
}:

buildPythonPackage {
  pname = "badldap";
  version = "0.7.1-unstable-2025-10-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "badldap";
    rev = "65af61fd7daf7dc7bef9c6248553398e6f604d43"; # no tag available
    hash = "sha256-14mV+EBrpoR9suPmOYdt2ro1Gcrpj3tuVx/meaVKC2c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    asysocks
    badauth
    kerbad
    prompt-toolkit
    tabulate
    tqdm
    unicrypto
    unidns
    wcwidth
    winacl
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "badldap" ];

  meta = {
    description = "LDAP library for auditing MS AD";
    homepage = "https://github.com/CravateRouge/badldap";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
