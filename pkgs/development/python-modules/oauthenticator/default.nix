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
  version = "16.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-opF7HdTJX4M7gTgB0VyWyyG/DO7lrVTvTcxMBX3a6UE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=oauthenticator" ""
  '';

  propagatedBuildInputs = [
    jupyterhub
  ];

  passthru.optional-dependencies = {
    azuread = [
      pyjwt
    ];
    googlegroups = [
      google-api-python-client
      google-auth-oauthlib
    ];
    mediawiki = [
      mwoauth
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    requests-mock
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = [
    # Tests are outdated, https://github.com/jupyterhub/oauthenticator/issues/432
    "test_azuread"
    "test_mediawiki"
  ];

  pythonImportsCheck = [
    "oauthenticator"
  ];

  meta = with lib; {
    description = "Authenticate JupyterHub users with common OAuth providers";
    homepage =  "https://github.com/jupyterhub/oauthenticator";
    changelog = "https://github.com/jupyterhub/oauthenticator/blob/${version}/docs/source/reference/changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
