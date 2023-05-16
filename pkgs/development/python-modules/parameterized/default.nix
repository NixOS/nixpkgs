{ lib
, buildPythonPackage
, fetchPypi
, mock
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
, setuptools
=======
, nose
, pytestCheckHook
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "parameterized";
<<<<<<< HEAD
  version = "0.9.0";
  format = "pyproject";
=======
  version = "0.8.1";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-f8kFJyzvpPNkwaNCnLvpwPmLeTmI77W/kKrIDwjbCbE=";
  };

  postPatch = ''
    # broken with pytest 7
    # https://github.com/wolever/parameterized/issues/167
    substituteInPlace parameterized/test.py \
      --replace 'assert_equal(missing, [])' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    mock
=======
    hash = "sha256-Qbv/N9YYZDD3f5ANd35btqJJKKHEb7HeaS+LUriDO1w=";
  };

  checkInputs = [
    mock
    nose
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "parameterized/test.py"
  ];

<<<<<<< HEAD
=======
  disabledTests = [
    # Tests seem outdated
    "test_method"
    "test_with_docstring_0_value1"
    "test_with_docstring_1_v_l_"
    "testCamelCaseMethodC"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "parameterized"
  ];

  meta = with lib; {
    description = "Parameterized testing with any Python test framework";
    homepage = "https://github.com/wolever/parameterized";
    changelog = "https://github.com/wolever/parameterized/blob/v${version}/CHANGELOG.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
