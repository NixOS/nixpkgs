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
    hash = "sha256-dYCBu9sosmMTuxjJ2Korj83JFi5NOrGWxiZWfmTxq4s=";
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
