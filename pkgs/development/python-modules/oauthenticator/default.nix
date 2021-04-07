{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, google-api-python-client
, google-auth-oauthlib
, jupyterhub
, mwoauth
, pyjwt
, pytest-asyncio
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "oauthenticator";
  version = "0.13.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5202adcd96ddbbccbc267da02f2d14e977300c81291aaa77be4fd9f2e27cfa37";
  };

  propagatedBuildInputs = [
    jupyterhub
  ];

  pytestFlagsArray = [ "oauthenticator/tests" ];

  checkInputs = [
    google-api-python-client
    google-auth-oauthlib
    mwoauth
    pyjwt
    pytest-asyncio
    pytestCheckHook
    requests-mock
  ];

  meta = with lib; {
    description = "Authenticate JupyterHub users with common OAuth providers, including GitHub, Bitbucket, and more.";
    homepage =  "https://github.com/jupyterhub/oauthenticator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
