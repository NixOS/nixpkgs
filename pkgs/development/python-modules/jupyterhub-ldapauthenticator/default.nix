{
  lib,
  buildPythonPackage,
  jupyterhub,
  ldap3,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "jupyterhub-ldapauthenticator";
  version = "1.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "758081bbdb28b26313bb18c9d8aa2b8fcdc9162e4d3ab196c626567e64f1ab8b";
  };

  # No tests implemented
  doCheck = false;

  propagatedBuildInputs = [
    jupyterhub
    ldap3
  ];

  meta = with lib; {
    description = "Simple LDAP Authenticator Plugin for JupyterHub";
    homepage = "https://github.com/jupyterhub/ldapauthenticator";
    license = licenses.bsd3;
  };
}
