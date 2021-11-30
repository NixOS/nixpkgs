{ lib
, buildPythonPackage
, fetchFromGitHub
, sqlite
, isPyPy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.33.0-r1";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = version;
    sha256 = "05mxcw1382xx22285fnv92xblqby3adfrvvalaw4dc6rzsn6kcan";
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
