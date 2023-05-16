<<<<<<< HEAD
{ lib
, buildPythonPackage
, callPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
=======
{ buildPythonPackage
, callPackage
, pytest-cov
, fetchPypi
, lib
, pytest
, pythonOlder
, pytest-runner
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pycategories";
  version = "1.2.0";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vXDstelOdlnlZOoVPwx2cykdw3xSbCRoAPwI1sU3gJk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
    substituteInPlace setup.cfg \
      --replace "--cov-report term --cov=categories" ""
  '';
=======
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd70ecb5e94e7659e564ea153f0c7673291dc37c526c246800fc08d6c5378099";
  };

  nativeBuildInputs = [ pytest-runner ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Is private because the author states it's unmaintained
  # and shouldn't be used in production code
  propagatedBuildInputs = [ (callPackage ./infix.nix { }) ];

<<<<<<< HEAD
  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Implementation of some concepts from category theory";
    homepage = "https://gitlab.com/danielhones/pycategories";
    changelog = "https://gitlab.com/danielhones/pycategories/-/blob/v${version}/CHANGELOG.rst";
=======
  nativeCheckInputs = [ pytest pytest-cov ];

  meta = with lib; {
    homepage = "https://gitlab.com/danielhones/pycategories";
    description = "Implementation of some concepts from category theory";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ dmvianna ];
  };
}
