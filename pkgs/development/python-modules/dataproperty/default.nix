<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchFromGitHub
, loguru
, mbstrdecoder
, pytestCheckHook
, pythonOlder
, tcolorpy
, termcolor
, typepy
=======
{ buildPythonPackage
, fetchFromGitHub
, lib
, mbstrdecoder
, typepy
, pytestCheckHook
, termcolor
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "dataproperty";
<<<<<<< HEAD
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.55.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-adUxUU9eASkC9n5ppZYNN0MP19u4xcL8XziBWSCp2L8=";
  };

  propagatedBuildInputs = [
    mbstrdecoder
    typepy
    tcolorpy
  ] ++ typepy.optional-dependencies.datetime;

  passthru.optional-dependencies = {
    logging = [
      loguru
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    termcolor
  ];

  pythonImportsCheck = [
    "dataproperty"
  ];

  meta = with lib; {
    description = "Library for extracting properties from data";
    homepage = "https://github.com/thombashi/dataproperty";
    changelog = "https://github.com/thombashi/DataProperty/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ genericnerdyusername ];
=======
    rev = "v${version}";
    hash = "sha256-ODSrKZ8M/ni9r2gkVIKWaKkdr+3AVi4INkEKJ+cmb44=";
  };

  propagatedBuildInputs = [ mbstrdecoder typepy ];

  nativeCheckInputs = [ pytestCheckHook ];
  checkInputs = [ termcolor ];

  # Tests fail, even on non-nixos
  pytestFlagsArray = [
    "--deselect test/test_dataproperty.py::Test_DataPeroperty_len::test_normal_ascii_escape_sequence"
    "--deselect test/test_dataproperty.py::Test_DataPeroperty_is_include_ansi_escape::test_normal"
    "--deselect test/test_dataproperty.py::Test_DataPeroperty_repr::test_normal"
  ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/dataproperty";
    description = "A library for extracting properties from data";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
