{
  lib,
  stdenv,
  asgiref,
  autobahn,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hypothesis,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  twisted,
}:

buildPythonPackage (finalAttrs: {
  pname = "daphne";
  version = "4.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django";
    repo = "daphne";
    tag = finalAttrs.version;
    hash = "sha256-xdHvJZ+JfVYBpSvZ83mCgLSYgiIxZUS0Yx6Kg706aN4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    autobahn
    twisted
  ]
  ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    django
    hypothesis
    pytest-asyncio
    pytestCheckHook
  ];

  # Most tests fail on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "daphne" ];

  meta = {
    description = "Django ASGI (HTTP/WebSocket) server";
    homepage = "https://github.com/django/daphne";
    changelog = "https://github.com/django/daphne/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "daphne";
  };
})
