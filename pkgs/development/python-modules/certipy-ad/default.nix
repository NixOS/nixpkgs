{
  lib,
  argcomplete,
  asn1crypto,
  beautifulsoup4,
  buildPythonPackage,
  cryptography,
  dnspython,
  dsinternals,
  fetchFromGitHub,
  httpx,
  impacket,
  ldap3,
  pyasn1,
  pycryptodome,
  pyopenssl,
  requests,
  setuptools,
  unicrypto,
}:

buildPythonPackage (finalAttrs: {
  pname = "certipy-ad";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ly4k";
    repo = "Certipy";
    tag = finalAttrs.version;
    hash = "sha256-q9Gn3eBPKK8emm9upy3hJ1HaBdyTrMgek/hq+Xi2ZZg=";
  };

  pythonRelaxDeps = [
    "argcomplete"
    "beautifulsoup4"
    "cryptography"
    "dnspython"
    "ldap3"
    "pycryptodome"
    "pyopenssl"
    "beautifulsoup4"
    "requests"
  ];

  build-system = [ setuptools ];

  dependencies = [
    argcomplete
    asn1crypto
    beautifulsoup4
    cryptography
    dnspython
    dsinternals
    httpx
    impacket
    ldap3
    pyasn1
    pycryptodome
    pyopenssl
    requests
    setuptools
    unicrypto
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "certipy" ];

  meta = {
    description = "Library and CLI tool to enumerate and abuse misconfigurations in Active Directory Certificate Services";
    homepage = "https://github.com/ly4k/Certipy";
    changelog = "https://github.com/ly4k/Certipy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "certipy";
  };
})
