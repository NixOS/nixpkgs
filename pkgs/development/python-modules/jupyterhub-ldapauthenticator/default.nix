{ lib
, buildPythonPackage
, jupyterhub
, ldap3
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jupyterhub-ldapauthenticator";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12xby5j7wmi6qsbb2fjd5qbckkcg5fmdij8qpc9n7ci8vfxq303m";
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
