{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, anyio
, certifi
, h11
, h2
, pproxy
, pytest-asyncio
, pytestCheckHook
, pytest-cov
, pytest-httpbin
, pytest-trio
, sniffio
, socksio
, trio
, trustme
, uvicorn
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.14.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "sha256-eqUkzK6UNpu8/mOmy4o53z3q/05m7t0bWtpeDfAHuJU=";
  };

  propagatedBuildInputs = [
    anyio
    certifi
    h11
    h2
    sniffio
    socksio
  ];

  checkInputs = [
    pproxy
    pytest-asyncio
    pytestCheckHook
    pytest-cov
    pytest-httpbin
    pytest-trio
    trio
    trustme
    uvicorn
  ];

  pythonImportsCheck = [ "httpcore" ];

  meta = with lib; {
    description = "A minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
