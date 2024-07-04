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
  version = "16.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gFhhOCcmorkrLxrup9fICh5ueCrc64fxfuZXTQG1tMk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=oauthenticator" ""
  '';

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

  passthru.optional-dependencies = {
    googlegroups = [
      google-api-python-client
      google-auth-oauthlib
    ];
    mediawiki = [ mwoauth ];
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
    maintainers = with maintainers; [ ];
  };
}
