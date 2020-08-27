{ lib
, buildPythonPackage
, fetchFromGitHub
, certifi
, chardet
, h11
, h2
, httpcore
, idna
, rfc3986
, sniffio
, isPy27
, pytest
, pytest-asyncio
, pytest-trio
, pytestcov
, trustme
, uvicorn
, brotli
}:

buildPythonPackage rec {
  pname = "httpx";
  version = "0.14.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "08b6k5g8car3bic90aw4ysb2zvsa5nm8qk3hk4dgamllnnxzl5br";
  };

  propagatedBuildInputs = [
    certifi
    chardet
    h11
    h2
    httpcore
    idna
    rfc3986
    sniffio
  ];

  checkInputs = [
    pytest
    pytest-asyncio
    pytest-trio
    pytestcov
    trustme
    uvicorn
    brotli
  ];

  checkPhase = ''
    PYTHONPATH=.:$PYTHONPATH pytest -k 'not (test_connect_timeout or test_elapsed_timer)'
  '';
  pythonImportsCheck = [ "httpx" ];

  meta = with lib; {
    description = "The next generation HTTP client";
    homepage = "https://github.com/encode/httpx";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
