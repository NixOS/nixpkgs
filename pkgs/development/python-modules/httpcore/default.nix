{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, h11
, h2
, pproxy
, pytestCheckHook
, pytestcov
, sniffio
, uvicorn
, trustme
, trio
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.12.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "09hbjc5wzhrnri5y3idxcq329d7jiaxljc7y6npwv9gh9saln109";
  };

  propagatedBuildInputs = [
    h11
    h2
    sniffio
  ];

  checkInputs = [
    pproxy
    pytestCheckHook
    pytestcov
    uvicorn
    trustme
    trio
  ];

  pytestFlagsArray = [
    # these tests fail during dns lookups: httpcore.ConnectError: [Errno -2] Name or service not known
    "--ignore=tests/test_threadsafety.py"
    "--ignore=tests/sync_tests/test_interfaces.py"
    "--ignore=tests/sync_tests/test_retries.py"
  ];

  pythonImportsCheck = [ "httpcore" ];

  meta = with lib; {
    description = "A minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
