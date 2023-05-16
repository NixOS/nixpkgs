{ lib
, buildPythonPackage
, fetchFromGitHub
, pytoolconfig
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "rope";
<<<<<<< HEAD
  version = "1.9.0";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-rope";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-j65C3x3anhH23D4kic5j++r/Ft0RqgZ/jFrNrNHVcXA=";
=======
    hash = "sha256-avNCti288dY9pl5AVTmUzZU/vb6WDkXEtELNlEi6L/o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pytoolconfig
  ] ++ pytoolconfig.optional-dependencies.global;

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    "test_search_submodule"
    "test_get_package_source_pytest"
    "test_get_modname_folder"
  ];

  meta = with lib; {
    description = "Python refactoring library";
    homepage = "https://github.com/python-rope/rope";
    changelog = "https://github.com/python-rope/rope/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ goibhniu ];
  };
}
