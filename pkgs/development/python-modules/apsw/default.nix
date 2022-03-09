{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, sqlite
, isPyPy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.37.0-r1";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = version;
    sha256 = "0p6rlbk7p6hj5mbmk1a8phazw3ym6hf5103zkxzg4p1jgjgi0xpl";
  };

  buildInputs = [
    sqlite
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  disabledTests = [
    "testCursor"
    "testLoadExtension"
    "testShell"
    "testVFS"
    "testVFSWithWAL"
    "testdb"
  ] ++ lib.optionals stdenv.isDarwin [
    # This is https://github.com/rogerbinns/apsw/issues/277 but
    # because we use pytestCheckHook we need to blacklist the test
    # manually
    "testzzForkChecker"
  ];

  pythonImportsCheck = [
    "apsw"
  ];

  meta = with lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = "https://github.com/rogerbinns/apsw";
    license = licenses.zlib;
    maintainers = with maintainers; [ ];
  };
}
