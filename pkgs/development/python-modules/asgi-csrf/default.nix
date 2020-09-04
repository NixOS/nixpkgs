{ stdenv, buildPythonPackage, isPy27, fetchFromGitHub, itsdangerous, python-multipart
, pytest, starlette, httpx, pytest-asyncio }:

buildPythonPackage rec {
  version = "0.7";
  pname = "asgi-csrf";
  disabled = isPy27;

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "1vf4lh007790836cp3hd6wf8wsgj045dcg0w1cm335p08zz6j4k7";
  };

  propagatedBuildInputs = [ itsdangerous python-multipart ];

  checkInputs = [ pytest starlette httpx pytest-asyncio ];
  checkPhase = ''
    pytest test_asgi_csrf.py
  '';
  pythonImportsCheck = [ "asgi_csrf" ];

  meta = with stdenv.lib; {
    description = "ASGI middleware for protecting against CSRF attacks";
    license = licenses.asl20;
    homepage = "https://github.com/simonw/asgi-csrf";
    maintainers = [ maintainers.ris ];
  };
}
