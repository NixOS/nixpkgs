{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  itsdangerous,
  python-multipart,

  # tests
  asgi-lifespan,
  pytestCheckHook,
  starlette,
  httpx,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "asgi-csrf";
  version = "0.11";
  pyproject = true;

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "simonw";
    repo = "asgi-csrf";
    tag = version;
    hash = "sha256-STitMWabAPz61AU+5gFJSHBBqf67Q8UtS6ks8Q/ZybY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    itsdangerous
    python-multipart
  ];

  nativeCheckInputs = [
    asgi-lifespan
    httpx
    pytest-asyncio
    pytestCheckHook
    starlette
  ];

  pythonImportsCheck = [ "asgi_csrf" ];

  meta = with lib; {
    description = "ASGI middleware for protecting against CSRF attacks";
    license = licenses.asl20;
    homepage = "https://github.com/simonw/asgi-csrf";
    maintainers = [ maintainers.ris ];
  };
}
