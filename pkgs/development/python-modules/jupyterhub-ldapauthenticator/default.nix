{ lib
, buildPythonPackage
, jupyterhub
, ldap3
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jupyterhub-ldapauthenticator";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19dz3a3122wln8lkixj5jbh9x3cqlrcb3p7a53825cj72cmpcxwz";
  };

  # No tests implemented
  doCheck = false;
   
  propagatedBuildInputs = [ jupyterhub ldap3 ];

  meta = with lib; {
    description = "Simple LDAP Authenticator Plugin for JupyterHub";
    homepage =  https://github.com/jupyterhub/ldapauthenticator;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
