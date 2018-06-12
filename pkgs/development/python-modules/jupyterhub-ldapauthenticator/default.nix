{ lib
, buildPythonPackage
, jupyterhub
, ldap3
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jupyterhub-ldapauthenticator";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "192406a8872727fdf4651aaa0d47cc91401c173399db1b835084ef86dbba49e2";
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
