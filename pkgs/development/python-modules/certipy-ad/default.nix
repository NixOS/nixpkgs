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
  pythonOlder,
  requests,
  setuptools,
  unicrypto,
}:

buildPythonPackage rec {
  pname = "certipy-ad";
  version = "5.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ly4k";
    repo = "Certipy";
    tag = version;
    hash = "sha256-riFhpB8AMDewz7s4d7jKwmezTHFHJrenC3pWKzfAk6Q=";
  };

  pythonRelaxDeps = [
    "argcomplete"
    "cryptography"
    "pycryptodome"
    "pyopenssl"
  ];

  pythonRemoveDeps = [ "bs4" ];

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

  meta = with lib; {
    description = "Library and CLI tool to enumerate and abuse misconfigurations in Active Directory Certificate Services";
    homepage = "https://github.com/ly4k/Certipy";
    changelog = "https://github.com/ly4k/Certipy/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "certipy";
  };
}
