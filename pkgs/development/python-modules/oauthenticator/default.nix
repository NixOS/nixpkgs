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
  version = "14.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zfcl3dq9ladqg7fnpx6kgxf1ckjzlc8v3j6wa8w6iwglm40ax4r";
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

  postPatch = ''
  # The constraint was removed. No longer needed for > 14.0.0
  # https://github.com/jupyterhub/oauthenticator/pull/431
    substituteInPlace test-requirements.txt --replace "pyjwt>=1.7,<2.0" "pyjwt"
  '';

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
