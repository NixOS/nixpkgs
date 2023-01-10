{ lib
, buildPythonPackage
, fetchPypi
, dnspython
, future
, ldap3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ldapdomaindump";
  version = "0.9.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mdzaFwUKllSZZuU7yJ5x2mcAlNU9lUKzsNAZfQNeb1I=";
  };

  propagatedBuildInputs = [
    dnspython
    future
    ldap3
  ];

  # requires ldap server
  doCheck = false;

  pythonImportsCheck = [
    "ldapdomaindump"
  ];

  meta = with lib; {
    description = "Active Directory information dumper via LDAP";
    homepage = "https://github.com/dirkjanm/ldapdomaindump/";
    changelog = "https://github.com/dirkjanm/ldapdomaindump/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
