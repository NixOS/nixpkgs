{
  lib,
  asn1crypto,
  asysocks,
  badauth,
  buildPythonPackage,
  fetchFromGitHub,
  kerbad,
  prompt-toolkit,
  setuptools,
  tabulate,
  tqdm,
  unicrypto,
  wcwidth,
  winacl,
}:

buildPythonPackage rec {
  pname = "badldap";
  version = "0.5.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "badldap";
    tag = version;
    hash = "sha256-CnHXEE1tdIXv+Qb3pS+cNxVtcTOVaq6mrQxu3wr1Xxo=";
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
