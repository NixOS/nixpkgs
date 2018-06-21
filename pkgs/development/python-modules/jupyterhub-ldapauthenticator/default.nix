{ lib
, buildPythonPackage
, jupyterhub
, ldap3
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jupyterhub-ldapauthenticator";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bba2ee246834130c9f86c13d39585b1af21563b814fa03aacb26b6696dd7e20";
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
