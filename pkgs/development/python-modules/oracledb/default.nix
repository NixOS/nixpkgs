{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cryptography
, cython
}:

buildPythonPackage rec {
  pname = "oracledb";
<<<<<<< HEAD
  version = "1.4.0";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-lrpQj3g4ksfKZI8misvLikqcgDfH3UpQnwXyyJ1iMb4=";
=======
    hash = "sha256-8QWkcFkWoo0z4pGPo2NAl/6DVSv16oGvw6emhSjJ4vM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
