{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pybind11
, re2
, six
}:

buildPythonPackage rec {
  pname = "google-re2";
<<<<<<< HEAD
  version = "1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-06lGfuUrRqx3ypKPbQy+rM/ZLwPKDw9lud9qlRhPOhw=";
=======
  version = "1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IcitwpY2DeH/QmuqOMcS6tpiLChY0ZXrSH5BXZQZTpE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pybind11
    re2
    six
  ];

  pythonImportsCheck = [
    "re2"
  ];

  meta = with lib; {
    description = "RE2 Python bindings";
    homepage = "https://github.com/google/re2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alexbakker ];
  };
}
