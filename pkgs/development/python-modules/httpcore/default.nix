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
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.12.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "0bwxn7m7r7h6k41swxj0jqj3nzi76wqxwbnry6y7d4qfh4m26g2j";
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
  ];

  pytestFlagsArray = [
    # these tests fail during dns lookups: httpcore.ConnectError: [Errno -2] Name or service not known
    "--ignore=tests/sync_tests/test_interfaces.py"
  ];

  pythonImportsCheck = [ "httpcore" ];

  meta = with lib; {
    description = "A minimal low-level HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
  };
}
