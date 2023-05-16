{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, build
, hatchling
, tomli
, typing-extensions
}:

buildPythonPackage rec {
  pname = "hatch-fancy-pypi-readme";
<<<<<<< HEAD
  version = "23.1.0";
=======
  version = "22.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "hatch_fancy_pypi_readme";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-sd9EBjCUrx6CSM6s1HqSyc8xPWuYI79mr4qSfDlgKH0=";
=======
    hash = "sha256-2pEoLKCWAcGK3tjjeNr4tXjHAhSGbwlxFW7pu5zmwmo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    hatchling
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    build
    pytestCheckHook
  ];

  # Requires network connection
  disabledTests = [
    "test_build"  # Requires internet
    "test_invalid_config"
  ];

  pythonImportsCheck = [
    "hatch_fancy_pypi_readme"
  ];

  meta = with lib; {
    description = "Fancy PyPI READMEs with Hatch";
    homepage = "https://github.com/hynek/hatch-fancy-pypi-readme";
    license = licenses.mit;
    maintainers = with maintainers; [ tjni ];
  };
}
