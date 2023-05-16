{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, awkward-cpp
, hatch-fancy-pypi-readme
, hatchling
, numba
, numpy
, packaging
<<<<<<< HEAD
, setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "awkward";
<<<<<<< HEAD
  version = "2.3.1";
=======
  version = "2.0.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-NLROXEbh4MKvBFuj+4+Wa2u37P9vuQ0Ww8kK+CYWt5E=";
=======
    hash = "sha256-MqV8KeE6KuO8HmrFNjeCW70ixChmlhY71Bod7ChKjuU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  propagatedBuildInputs = [
    awkward-cpp
    numpy
    packaging
  ]  ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    pytestCheckHook
    numba
<<<<<<< HEAD
    setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTestPaths = [
    "tests-cuda"
  ];

  pythonImportsCheck = [
    "awkward"
  ];

  meta = with lib; {
    description = "Manipulate JSON-like data with NumPy-like idioms";
    homepage = "https://github.com/scikit-hep/awkward";
<<<<<<< HEAD
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
