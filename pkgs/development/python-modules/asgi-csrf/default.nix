{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, itsdangerous
, python-multipart
, pytestCheckHook
, starlette
, httpx
, pytest-asyncio
}:

buildPythonPackage rec {
  version = "0.8";
  pname = "asgi-csrf";
  disabled = isPy27;

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "sha256-0I/p9SjVVZhJQeR7s1R3tooP9XMNLPlcxl0dBSzsVaw=";
  };

  propagatedBuildInputs = [
    itsdangerous
    python-multipart
  ];

  checkInputs = [
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
