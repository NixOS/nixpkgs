{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, anyio
, h11
, h2
, pproxy
, pytest-asyncio
, pytestCheckHook
, pytest-cov
, sniffio
, trio
, trustme
, uvicorn
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.13.7";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "sha256-9hG9MqqEYMT2j7tXafToGYwHbJfp9/klNqZozHSbweE=";
  };

  propagatedBuildInputs = [
    anyio
    h11
    h2
    sniffio
  ];

  checkInputs = [
    pproxy
    pytest-asyncio
    pytestCheckHook
    pytest-cov
    trio
    trustme
    uvicorn
  ];

  disabledTestPaths = [
    # these tests fail during dns lookups: httpcore.ConnectError: [Errno -2] Name or service not known
    "tests/test_threadsafety.py"
    "tests/async_tests/"
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
