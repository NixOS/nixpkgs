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
  version = "14.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4baa02ff2c159cbba06f8d07fe11a6e624285ca2f813b1258b4c68766c0ee46b";
  };

  propagatedBuildInputs = [
    jupyterhub
  ];

  checkInputs = [
    google-api-python-client
    google-auth-oauthlib
    mwoauth
    pyjwt
    pytest-asyncio
    pytestCheckHook
    requests-mock
  ];

  disabledTests = [
    # Test are outdated, https://github.com/jupyterhub/oauthenticator/issues/432
    "test_azuread"
    "test_mediawiki"
  ];

  pythonImportsCheck = [ "oauthenticator" ];

  meta = with lib; {
    description = "Authenticate JupyterHub users with common OAuth providers, including GitHub, Bitbucket, and more.";
    homepage =  "https://github.com/jupyterhub/oauthenticator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
