{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
, pytest-runner
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "mwparserfromhell";
<<<<<<< HEAD
  version = "0.6.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K60L/2FFdjmeRHDWQAuinFLVlWgqS43mQq+7W+v0o0Y=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mwparserfromhell"
=======
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kr7JUorjTScok8yvK1J9+FwxT/KM+7MFY0BGewldg0w=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-runner
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "MWParserFromHell is a parser for MediaWiki wikicode";
<<<<<<< HEAD
    homepage = "https://mwparserfromhell.readthedocs.io/";
    changelog = "https://github.com/earwig/mwparserfromhell/releases/tag/v${version}";
=======
    homepage = "https://mwparserfromhell.readthedocs.io/en/latest/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ melling ];
  };
}
