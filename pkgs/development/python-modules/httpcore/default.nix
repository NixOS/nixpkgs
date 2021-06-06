{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, h11
, h2
, pproxy
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, pytestcov
, sniffio
, trustme
, uvicorn
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.13.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "sha256-KvqBVQUaF3p2oJz0tt3Bkn2JiKEHqrZ3b6I9f0JK5h8=";
  };

  propagatedBuildInputs = [
    h11
    h2
    sniffio
  ];

  checkInputs = [
    pproxy
    pytest-asyncio
    pytest-trio
    pytestCheckHook
    pytestcov
    trustme
    uvicorn
  ];

  disabledTestPaths = [
    # these tests fail during dns lookups: httpcore.ConnectError: [Errno -2] Name or service not known
    "tests/test_threadsafety.py"
    "tests/sync_tests/test_interfaces.py"
    "tests/sync_tests/test_retries.py"
  ];

  pythonImportsCheck = [ "httpcore" ];

  meta = with lib; {
    description = "A minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
