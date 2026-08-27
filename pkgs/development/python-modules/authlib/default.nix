{
  lib,
  buildPythonPackage,
  cachelib,
  cryptography,
  fetchFromGitHub,
  flask-sqlalchemy,
  flask,
  httpx,
  joserfc,
  mock,
  django,
  anyio,
  pytest-django,
  pytest-asyncio,
  pycryptodomex,
  pytestCheckHook,
  python-multipart,
  requests,
  setuptools,
  starlette,
  werkzeug,
}:

buildPythonPackage (finalAttrs: {
  pname = "authlib";
  version = "1.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FLSe9piZoFlOAutzoMcgygbsJsR8uSlZWqdNBU6D+aE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    joserfc
  ];

  optional-dependencies = {
    clients = [
      anyio
      cachelib
      django
      flask
      httpx
      requests
      starlette
    ]
    ++ starlette.optional-dependencies.full;
    django = [
      django
      pytest-django
    ];
    flask = [
      flask
      flask-sqlalchemy
    ];
    jose = [ pycryptodomex ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "authlib" ];

  disabledTestPaths = [
    # Django tests require a running instance
    "tests/django/"
    "tests/clients/test_django/"
    # Unsupported encryption algorithm
    "tests/jose/test_chacha20.py"
  ];

  disabledTests = [
    # AssertionError
    "test_access_resource"
    "test_entitlements_restriction"
    "test_extra_attributes"
    "test_introspection"
    "test_scope_restriction"
    "test_typ"
  ];

  meta = {
    description = "Library for building OAuth and OpenID Connect servers";
    homepage = "https://github.com/lepture/authlib";
    changelog = "https://github.com/lepture/authlib/blob/${finalAttrs.src.tag}/docs/upgrades/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ flokli ];
  };
})
