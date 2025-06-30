{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dnspython,
  ldap3,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ldapdomaindump";
  version = "0.10.0-unstable-2025-04-06";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dirkjanm";
    repo = "ldapdomaindump";
    rev = "d559463eb29857f2660bf3867bfb9f8610d1ddb1";
    hash = "sha256-gb/3gtXPQ86bkvunvj1wonxYAFHKkCh2H5dmSNTgz5g=";
  };

  propagatedBuildInputs = [
    dnspython
    ldap3
  ];

  # requires ldap server
  doCheck = false;

  pythonImportsCheck = [ "ldapdomaindump" ];

  meta = with lib; {
    description = "Active Directory information dumper via LDAP";
    homepage = "https://github.com/dirkjanm/ldapdomaindump/";
    changelog = "https://github.com/dirkjanm/ldapdomaindump/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
