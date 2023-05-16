{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pyvirtualdisplay
<<<<<<< HEAD
, pythonOlder
=======
, isPy27
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pytest-xvfb";
<<<<<<< HEAD
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N0arH00RWfA/dRY40FNonM0oQpGzi4+wPT67579pz8A=";
  };

  buildInputs = [
    pytest
  ];
=======
  version = "2.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kyq5rg27dsnj7dc6x9y7r8vwf8rc88y2ppnnw6r96alw0nn9fn4";
  };

  buildInputs = [ pytest ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    pyvirtualdisplay
  ];

  meta = with lib; {
    description = "A pytest plugin to run Xvfb for tests";
    homepage = "https://github.com/The-Compiler/pytest-xvfb";
<<<<<<< HEAD
    changelog = "https://github.com/The-Compiler/pytest-xvfb/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
