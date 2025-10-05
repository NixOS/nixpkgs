{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dnspython,
  ldap3,
  pycryptodome,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ldapdomaindump";
  version = "0.10.0-unstable-2025-04-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dirkjanm";
    repo = "ldapdomaindump";
    rev = "d559463eb29857f2660bf3867bfb9f8610d1ddb1";
    hash = "sha256-gb/3gtXPQ86bkvunvj1wonxYAFHKkCh2H5dmSNTgz5g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dnspython
    ldap3
    pycryptodome
  ];

  # Tests require LDAP server
  doCheck = false;

  pythonImportsCheck = [ "ldapdomaindump" ];

  meta = with lib; {
    description = "Active Directory information dumper via LDAP";
    homepage = "https://github.com/dirkjanm/ldapdomaindump/";
    changelog = "https://github.com/dirkjanm/ldapdomaindump/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
