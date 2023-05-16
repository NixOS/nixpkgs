{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
, unittestCheckHook
<<<<<<< HEAD

# for passthru.tests
, awsebcli
, black
, hatchling
, yamllint
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pathspec";
  version = "0.11.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZNM41OCRTpHBeSMh5pB7Wlk/GrGFHef8JpVXohsw67w=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  pythonImportsCheck = [
    "pathspec"
  ];

  checkInputs = [
    unittestCheckHook
  ];

<<<<<<< HEAD
  passthru.tests = {
    inherit awsebcli black hatchling yamllint;
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = {
    description = "Utility library for gitignore-style pattern matching of file paths";
    homepage = "https://github.com/cpburnz/python-path-specification";
    changelog = "https://github.com/cpburnz/python-pathspec/blob/v${version}/CHANGES.rst";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ copumpkin ];
  };
}
