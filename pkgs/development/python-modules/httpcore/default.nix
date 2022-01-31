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
, sniffio
, trio
, trustme
, uvicorn
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.14.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "sha256-jPsbMhY1lWKBXlh6hsX6DGKXi/g7VQSU00tF6H7qkOo=";
  };

  propagatedBuildInputs = [
    anyio
    certifi
    h11
    h2
    sniffio
  ];

  checkInputs = [
    pproxy
    pytest-asyncio
    pytestCheckHook
    pytest-cov
    pytest-httpbin
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
