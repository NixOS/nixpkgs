{ lib
, stdenv
, buildPythonPackage
<<<<<<< HEAD
=======
, pythonAtLeast
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, fetchFromGitHub
, attrs
, django_3
, pytestCheckHook
, parso
}:

buildPythonPackage rec {
  pname = "jedi";
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.18.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "jedi";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Hw0+KQkB9ICWbBJDQQmHyKngzJlJ8e3wlpe4aSrlkvo=";
=======
    hash = "sha256-hNRmUFpRzVKJQAtfsSNV4jeTR8vVj1+mGBIPO6tUGto=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [ parso ];

  nativeCheckInputs = [
    attrs
    django_3
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # sensitive to platform, causes false negatives on darwin
    "test_import"
  ] ++ lib.optionals (stdenv.isAarch64 && pythonOlder "3.9") [
    # AssertionError: assert 'foo' in ['setup']
    "test_init_extension_module"
<<<<<<< HEAD
=======
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    # disabled until 3.11 is added to _SUPPORTED_PYTHONS in jedi/api/environment.py
    "test_find_system_environments"

    # disabled until https://github.com/davidhalter/jedi/issues/1858 is resolved
    "test_interpreter"
    "test_scanning_venvs"
    "test_create_environment_venv_path"
    "test_create_environment_executable"
    "test_venv_and_pths"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "An autocompletion tool for Python that can be used for text editors";
    homepage = "https://github.com/davidhalter/jedi";
    changelog = "https://github.com/davidhalter/jedi/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
