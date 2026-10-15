{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  hatchling,
  hatch-requirements-txt,
  tornado,
  traitlets,
}:

buildPythonPackage (finalAttrs: {
  pname = "oauthenticator";
  version = "17.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "oauthenticator";
    tag = finalAttrs.version;
    hash = "sha256-s5YRAVr0s1mYZU5lzxYsebOZBayF4FX99gkmbuII014=";
  };

  patches = [
    # Tests assert on the exact set of keys of the auth model, which fails
    # since JupyterHub 6 adds new user fields.
    # https://github.com/jupyterhub/oauthenticator/pull/841
    (fetchpatch {
      name = "dont-fail-tests-when-jupyterhub-adds-new-user-fields.patch";
      url = "https://github.com/jupyterhub/oauthenticator/commit/7c9ee3d9b4ab1a767aedef171efe02a084ca54db.patch";
      excludes = [ "oauthenticator/tests/test_oidc.py" ];
      hash = "sha256-iBUbXUXTXfMI+nSnp772/coSii8J81JTDKolE2ONicI=";
    })
  ];

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

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
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "oauthenticator" ];

  meta = {
    description = "Authenticate JupyterHub users with common OAuth providers";
    homepage = "https://github.com/jupyterhub/oauthenticator";
    changelog = "https://github.com/jupyterhub/oauthenticator/blob/${finalAttrs.src.rev}/docs/source/reference/changelog.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    teams = with lib.teams; [ jupyter ];
  };
})
