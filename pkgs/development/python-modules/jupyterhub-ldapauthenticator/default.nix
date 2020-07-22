{ lib
, buildPythonPackage
, jupyterhub
, ldap3
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jupyterhub-ldapauthenticator";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "920b115babdc32e7b159fc497a0a794bb0f57b222ce2c26c74a23594892f9d3c";
  };

  # No tests implemented
  doCheck = false;
   
  propagatedBuildInputs = [ jupyterhub ldap3 ];

  meta = with lib; {
    description = "Simple LDAP Authenticator Plugin for JupyterHub";
    homepage =  "https://github.com/jupyterhub/ldapauthenticator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
