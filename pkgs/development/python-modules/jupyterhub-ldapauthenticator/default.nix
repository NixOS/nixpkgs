{ lib
, buildPythonPackage
, jupyterhub
, ldap3
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jupyterhub-ldapauthenticator";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "913cc67a1e8c50e7e301a16f25a4125ffd020a7c5dd22ccfb3f7707af2ee9157";
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
