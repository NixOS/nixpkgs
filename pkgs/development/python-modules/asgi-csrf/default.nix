{
  lib,
  buildPythonPackage,
  isPy27,
  fetchFromGitHub,
  itsdangerous,
  python-multipart,
  pytestCheckHook,
  starlette,
  httpx,
  pytest-asyncio,
}:

buildPythonPackage rec {
  version = "0.11";
  format = "setuptools";
  pname = "asgi-csrf";
  disabled = isPy27;

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    tag = version;
    hash = "sha256-STitMWabAPz61AU+5gFJSHBBqf67Q8UtS6ks8Q/ZybY=";
  };

  propagatedBuildInputs = [
    itsdangerous
    python-multipart
  ];

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
    starlette
  ];

  doCheck = false; # asgi-lifespan missing

  pythonImportsCheck = [ "asgi_csrf" ];

  meta = with lib; {
    description = "ASGI middleware for protecting against CSRF attacks";
    license = licenses.asl20;
    homepage = "https://github.com/simonw/asgi-csrf";
    maintainers = [ maintainers.ris ];
  };
}
