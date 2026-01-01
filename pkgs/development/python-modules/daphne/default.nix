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

buildPythonPackage rec {
  pname = "daphne";
  version = "4.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django";
    repo = "daphne";
    tag = version;
    hash = "sha256-MPlvXcg7bBF1yaphjjMtnGsGpp6ca5GsgmXONw/V9Do=";
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

<<<<<<< HEAD
  meta = {
    description = "Django ASGI (HTTP/WebSocket) server";
    homepage = "https://github.com/django/daphne";
    changelog = "https://github.com/django/daphne/blob/${src.tag}/CHANGELOG.txt";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    homepage = "https://github.com/django/daphne";
    changelog = "https://github.com/django/daphne/blob/${src.tag}/CHANGELOG.txt";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "daphne";
  };
}
