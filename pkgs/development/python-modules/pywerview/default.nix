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
  setuptools,
}:

buildPythonPackage rec {
  pname = "pywerview";
  version = "0.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "the-useless-one";
    repo = "pywerview";
    tag = "v${version}";
    hash = "sha256-wl7/u9Uja/FflO3tN3UyanX2LIRG417RfWdyZCtUtGs=";
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

  meta = {
    description = "Module for PowerSploit's PowerView support";
    homepage = "https://github.com/the-useless-one/pywerview";
    changelog = "https://github.com/the-useless-one/pywerview/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pywerview";
  };
}
