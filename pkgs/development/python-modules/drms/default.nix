{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, six
, astropy
<<<<<<< HEAD
, oldest-supported-numpy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pytest-doctestplus
, pythonOlder
, setuptools-scm
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "drms";
<<<<<<< HEAD
  version = "0.6.4";
=======
  version = "0.6.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-fH290QRhhglkhkMrpwHUkqVuYvZ6w/MDIYo9V0queVY=";
  };

  nativeBuildInputs = [
    numpy
    oldest-supported-numpy
    setuptools-scm
    wheel
=======
    hash = "sha256-crPVo7ALErZWvNcsaJ/BuBa0VkfCsZ+C929x4kEZHKw=";
  };

  nativeBuildInputs = [
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    six
  ];

  nativeCheckInputs = [
    astropy
    pytestCheckHook
    pytest-doctestplus
  ];

  disabledTests = [
    "test_query_hexadecimal_strings"
  ];

  disabledTestPaths = [
    "docs/tutorial.rst"
  ];

  pythonImportsCheck = [ "drms" ];

  meta = with lib; {
    description = "Access HMI, AIA and MDI data with Python";
    homepage = "https://github.com/sunpy/drms";
    license = licenses.bsd2;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
