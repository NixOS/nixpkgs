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
, pytestcov
, sniffio
, trio
, trustme
, uvicorn
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.13.4";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "0vfdkd3bq14mnjd2gfg3ajsgygmd796md7pv96nicpx20prw3a2p";
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
    pytestcov
    trio
    trustme
    uvicorn
  ];

  postPatch = ''
    # The anyio 3.1.0 release is not picked-up proberly
    substituteInPlace setup.py --replace "anyio==3.*" "anyio"
  '';


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
