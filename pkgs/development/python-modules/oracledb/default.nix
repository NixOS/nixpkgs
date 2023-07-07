{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cryptography
, cython
}:

buildPythonPackage rec {
  pname = "oracledb";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/OG+vbDYuI+Qjg4dDY5cJM5E4b4EGzYDLCjDuojiExQ=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    cryptography
  ];

  doCheck = false;  # Checks need an Oracle database

  pythonImportsCheck = [
    "oracledb"
  ];

  meta = with lib; {
    description = "Python driver for Oracle Database";
    homepage = "https://oracle.github.io/python-oracledb";
    changelog = "https://github.com/oracle/python-oracledb/blob/v${version}/doc/src/release_notes.rst";
    license = with licenses; [ asl20 /* and or */ upl ];
    maintainers = with maintainers; [ harvidsen ];
  };
}
