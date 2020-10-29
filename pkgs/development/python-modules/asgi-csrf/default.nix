{ stdenv, buildPythonPackage, isPy27, fetchFromGitHub, itsdangerous, python-multipart
, pytestCheckHook, starlette, httpx, pytest-asyncio }:

buildPythonPackage rec {
  version = "0.7.1";
  pname = "asgi-csrf";
  disabled = isPy27;

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "1hhqrb9r46y6i3d3w6hc9zm6yyikdyd2k5pcbyw0r9fl959yi4hf";
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

  # tests fail while importing a private module from httpx
  #  E   ModuleNotFoundError: No module named 'httpx._content_streams'
  # https://github.com/simonw/asgi-csrf/issues/18
  doCheck = false;

  pythonImportsCheck = [ "asgi_csrf" ];

  meta = with stdenv.lib; {
    description = "ASGI middleware for protecting against CSRF attacks";
    license = licenses.asl20;
    homepage = "https://github.com/simonw/asgi-csrf";
    maintainers = [ maintainers.ris ];
  };
}
