{ lib
, buildPythonPackage
, colorful
, fetchFromGitHub
, git
, httpx
<<<<<<< HEAD
, lxml
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, packaging
, poetry-core
, pytestCheckHook
, python-dateutil
, pythonOlder
, semver
, rich
, tomlkit
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pontos";
<<<<<<< HEAD
  version = "23.9.0";
=======
  version = "23.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-7AU2K4XQ7B29IY53+uh0yre8RaOZ2GFc8hpyLWQilTE=";
=======
    hash = "sha256-nUVJjBebHOY0/oN/Cl2HdaLGnDVgLsUK7Yd+johP1PM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    colorful
    httpx
<<<<<<< HEAD
    lxml
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    packaging
    python-dateutil
    semver
    rich
    typing-extensions
    tomlkit
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ] ++ httpx.optional-dependencies.http2;

  nativeCheckInputs = [
    git
    pytestCheckHook
  ];

  disabledTests = [
    "PrepareTestCase"
    # Signing fails
    "test_find_no_signing_key"
    "test_find_signing_key"
    "test_find_unreleased_information"
    # CLI test fails
    "test_missing_cmd"
    "test_update_file_changed"
    # Network access
    "test_fail_sign_on_upload_fail"
    "test_successfully_sign"
<<<<<<< HEAD
    # calls git log, but our fetcher removes .git
    "test_git_error"
    # Tests require git executable
    "test_github_action_output"
    "test_initial_release"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "pontos"
  ];

  meta = with lib; {
    description = "Collection of Python utilities, tools, classes and functions";
    homepage = "https://github.com/greenbone/pontos";
    changelog = "https://github.com/greenbone/pontos/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
