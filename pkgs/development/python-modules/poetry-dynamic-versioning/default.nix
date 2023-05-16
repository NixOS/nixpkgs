{ lib
, buildPythonPackage
, dunamai
, fetchFromGitHub
, jinja2
<<<<<<< HEAD
=======
, markupsafe
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, poetry-core
, poetry
, pytestCheckHook
, pythonOlder
, tomlkit
}:

buildPythonPackage rec {
  pname = "poetry-dynamic-versioning";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "0.21.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-BGAo3c0TzyhIiDtZjoEP+Eeu51WJB3Wg71poFMWJ+VM=";
=======
    hash = "sha256-1RgxDXzijWr47mZeqfHfFnANdZKyY3QXCZoXijs5nTw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    dunamai
    jinja2
<<<<<<< HEAD
=======
    markupsafe
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    tomlkit
  ];

  nativeCheckInputs = [
    pytestCheckHook
    poetry
  ];

  # virtualenv: error: argument dest: the destination . is not write-able at /
  doCheck = false;

  disabledTests = [
    # these require .git, but leaveDotGit = true doesn't help
    "test__get_version__defaults"
    "test__get_version__format_jinja"
    # these expect to be able to run the poetry cli which fails in test hook
    "test_integration"
  ];

  pythonImportsCheck = [
    "poetry_dynamic_versioning"
  ];

<<<<<<< HEAD
  setupHook = ./setup-hook.sh;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Plugin for Poetry to enable dynamic versioning based on VCS tags";
    homepage = "https://github.com/mtkennerly/poetry-dynamic-versioning";
    changelog = "https://github.com/mtkennerly/poetry-dynamic-versioning/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
