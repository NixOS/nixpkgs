{ lib
, buildPythonPackage
, chardet
, fetchPypi
, jinja2
, jinja2_pluralize
, pluggy
, pycodestyle
, pyflakes
, pygments
, pylint
, pytest-datadir
, pytest-mock
, pytestCheckHook
, pythonOlder
, tomli
}:

buildPythonPackage rec {
  pname = "diff-cover";
<<<<<<< HEAD
  version = "7.7.0";
=======
  version = "7.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "diff_cover";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-YGFM9+ciz3+xveSXr6wLUUKU4eJlNESWItrE2ilhI/s=";
=======
    hash = "sha256-pLMCSoMeTzjCLoCZRfCdCmp7pmLcjjDSjxprIaPt6/w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    chardet
    jinja2
    jinja2_pluralize
    pluggy
    pygments
    tomli
  ];

  nativeCheckInputs = [
    pycodestyle
    pyflakes
    pylint
    pytest-datadir
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # Tests check for flake8
    "file_does_not_exist"
    # Comparing console output doesn't work reliable
    "console"
  ];

  pythonImportsCheck = [
    "diff_cover"
  ];

  meta = with lib; {
    description = "Automatically find diff lines that need test coverage";
    homepage = "https://github.com/Bachmann1234/diff-cover";
    changelog = "https://github.com/Bachmann1234/diff_cover/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dzabraev ];
  };
}
