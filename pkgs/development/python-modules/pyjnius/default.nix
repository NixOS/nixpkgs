<<<<<<< HEAD
{ lib
, buildPythonPackage
, cython
, fetchPypi
, jdk
, pythonOlder
=======
{ buildPythonPackage
, cython
, fetchPypi
, jdk
, lib
, six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pyjnius";
<<<<<<< HEAD
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZjRuJk8eIghrh8XINonqvP7xRQrGR2/YVr6kmLLhNz4=";
  };

  nativeBuildInputs = [
    jdk
    cython
  ];

  pythonImportsCheck = [
    "jnius"
  ];
=======
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/AY3zaSuEo7EqWrDJ9NS6H6oZnZLAdliZyhwvlOana4=";
  };
  propagatedBuildInputs = [
    six
  ];

  nativeBuildInputs = [ jdk cython ];

  pythonImportsCheck = [ "jnius" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A Python module to access Java classes as Python classes using the Java Native Interface (JNI)";
    homepage = "https://github.com/kivy/pyjnius";
<<<<<<< HEAD
    changelog = "https://github.com/kivy/pyjnius/blob/${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ ifurther ];
  };
}
