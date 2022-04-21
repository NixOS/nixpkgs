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
  version = "3.38.1-r1";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = version;
    hash = "sha256-pbb6wCu1T1mPlgoydB1Y1AKv+kToGkdVUjiom2vTqf4=";
  };

  buildInputs = [
    sqlite
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Works around the following error by dropping the call to that function
  #     def print_version_info(write=write):
  # >       write("                Python " + sys.executable + " " + str(sys.version_info) + "\n")
  # E       TypeError: 'module' object is not callable
  preCheck = ''
    sed -i '/print_version_info(write)/d' tests.py
  '';

  pytestFlagsArray = [
    "tests.py"
  ];

  disabledTests = [
    "testCursor"
    "testdb"
    "testLargeObjects"
    "testLoadExtension"
    "testShell"
    "testVFS"
    "testVFSWithWAL"
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
