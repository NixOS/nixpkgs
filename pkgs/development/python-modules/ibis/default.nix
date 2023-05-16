{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ibis";
  version = "3.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dmulholl";
    repo = pname;
    rev = version;
    hash = "sha256-EPz9zHnxR75WoRaiHKJNiCRWFwU1TBpC4uHz62jUOqM=";
  };

  checkPhase = ''
    ${python.interpreter} test_ibis.py
  '';

  pythonImportsCheck = [
    "ibis"
  ];

  meta = with lib; {
    description = "Lightweight template engine";
    homepage = "https://github.com/dmulholland/ibis";
    license = licenses.publicDomain;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
