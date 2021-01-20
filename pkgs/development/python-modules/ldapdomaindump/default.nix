{ lib, buildPythonPackage, fetchPypi, dnspython, future, ldap3 }:

buildPythonPackage rec {
  pname = "ldapdomaindump";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10cis8cllpa9qi5qil9k7521ag3921mxwg2wj9nyn0lk41rkjagc";
  };

  propagatedBuildInputs = [ dnspython future ldap3 ];

  # requires ldap server
  doCheck = false;
  pythonImportsCheck = [ "ldapdomaindump" ];

  meta = with lib; {
    description = "Active Directory information dumper via LDAP";
    homepage = "https://github.com/dirkjanm/ldapdomaindump/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
