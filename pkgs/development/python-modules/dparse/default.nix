{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, toml
, pyyaml
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dparse";
<<<<<<< HEAD
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J7uLS8rv7DmXaXuj9uBrJEcgC6JzwLCFw9ASoEVxtSg=";
=======
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1FJVvaIfmYvH3fKv1eYlBbphNHVrotQqhMVrCCZhTf4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    toml
    pyyaml
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dparse"
  ];

  disabledTests = [
    # requires unpackaged dependency pipenv
    "test_update_pipfile"
  ];

  meta = with lib; {
    description = "A parser for Python dependency files";
    homepage = "https://github.com/pyupio/dparse";
<<<<<<< HEAD
    changelog = "https://github.com/pyupio/dparse/blob/${version}/HISTORY.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr ];
  };
}
