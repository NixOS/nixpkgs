{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  impacket,
  ldap3-bleeding-edge,
  lxml,
  pyasn1,
  pycryptodome,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pywerview";
  version = "0.7.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "the-useless-one";
    repo = "pywerview";
    tag = "v${version}";
    hash = "sha256-PJCJyutlHApiA+5CxIpYzC13MSwd2n5zm+ZkJUppDTg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    impacket
    ldap3-bleeding-edge
    lxml
    pycryptodome
    pyasn1
  ];

  optional-dependencies = {
    kerberos = [ ldap3-bleeding-edge ] ++ ldap3-bleeding-edge.optional-dependencies.kerberos;
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pywerview" ];

  meta = with lib; {
    description = "Module for PowerSploit's PowerView support";
    homepage = "https://github.com/the-useless-one/pywerview";
    changelog = "https://github.com/the-useless-one/pywerview/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pywerview";
  };
}
