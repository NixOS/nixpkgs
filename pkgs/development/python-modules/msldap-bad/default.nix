{
  lib,
  asn1crypto,
  asyauth-bad,
  asysocks,
  buildPythonPackage,
  fetchFromGitHub,
  minikerberos-bad,
  prompt-toolkit,
  setuptools,
  tabulate,
  tqdm,
  unicrypto,
  wcwidth,
  winacl,
}:

buildPythonPackage rec {
  pname = "msldap-bad";
  version = "0.5.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "msldap-bAD";
    tag = version;
    hash = "sha256-CnHXEE1tdIXv+Qb3pS+cNxVtcTOVaq6mrQxu3wr1Xxo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asyauth-bad
    asn1crypto
    asysocks
    minikerberos-bad
    prompt-toolkit
    tabulate
    tqdm
    unicrypto
    wcwidth
    winacl
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "msldap" ];

  meta = {
    description = "LDAP library for auditing MS AD";
    homepage = "https://github.com/CravateRouge/msldap-bAD";
    changelog = "https://github.com/CravateRouge/asyauth-bAD/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
