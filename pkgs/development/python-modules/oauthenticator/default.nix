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
  version = "15.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0dmHPJtm4a+XMpGWi5Vz0lN4vYxkfzDXO42PsnsaC4U=";
  };

  propagatedBuildInputs = [
    jupyterhub
  ];

  nativeCheckInputs = [
    google-api-python-client
    google-auth-oauthlib
    mwoauth
    pyjwt
    pytest-asyncio
    pytestCheckHook
    requests-mock
  ];

  disabledTests = [
    # Tests are outdated, https://github.com/jupyterhub/oauthenticator/issues/432
    "test_azuread"
    "test_mediawiki"
  ];

  pythonImportsCheck = [
    "oauthenticator"
  ];

  meta = with lib; {
    description = "Authenticate JupyterHub users with common OAuth providers, including GitHub, Bitbucket, and more.";
    homepage =  "https://github.com/jupyterhub/oauthenticator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
