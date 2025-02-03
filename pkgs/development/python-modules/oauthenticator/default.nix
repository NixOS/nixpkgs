{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  google-api-python-client,
  google-auth-oauthlib,
  jsonschema,
  jupyterhub,
  mwoauth,
  pyjwt,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  requests,
  requests-mock,
  ruamel-yaml,
  setuptools,
  tornado,
  traitlets,
}:

buildPythonPackage rec {
  pname = "oauthenticator";
  version = "17.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YovSUu5o4dJ2wO1hXEe6Hc0Mf7hIH24DefBi5JV3H6c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
    jupyterhub
    pyjwt
    requests
    ruamel-yaml
    tornado
    traitlets
  ];

  optional-dependencies = {
    googlegroups = [
      google-api-python-client
      google-auth-oauthlib
    ];
    mediawiki = [ mwoauth ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    requests-mock
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTests = [
    # Tests are outdated, https://github.com/jupyterhub/oauthenticator/issues/432
    "test_azuread"
    "test_mediawiki"
    # Tests require network access
    "test_allowed"
    "test_auth0"
    "test_bitbucket"
    "test_cilogon"
    "test_github"
    "test_gitlab"
    "test_globus"
    "test_google"
    "test_openshift"
  ];

  pythonImportsCheck = [ "oauthenticator" ];

  meta = with lib; {
    description = "Authenticate JupyterHub users with common OAuth providers";
    homepage = "https://github.com/jupyterhub/oauthenticator";
    changelog = "https://github.com/jupyterhub/oauthenticator/blob/${version}/docs/source/reference/changelog.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
