{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, passlib
, python-dateutil
, pythonOlder
, scramp
, setuptools
<<<<<<< HEAD
, versioningit
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.29.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dtKqF1ejC8ceAwfa4Yw3TjNqaRI+awRuIGqWYR+iozA=";
  };

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    versioningit
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    passlib
    python-dateutil
    scramp
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    sed '/^\[metadata\]/a version = ${version}' setup.cfg
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Tests require a running PostgreSQL instance
  doCheck = false;

  pythonImportsCheck = [
    "pg8000"
  ];

  meta = with lib; {
    description = "Python driver for PostgreSQL";
    homepage = "https://github.com/tlocke/pg8000";
    changelog = "https://github.com/tlocke/pg8000#release-notes";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };
}
