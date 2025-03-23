{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  hatchling,
  hatch-vcs,

  # dependencies
  click,
  httpx,
  pydantic,
  pydantic-settings,
  questionary,
  rich-click,
  rich,
  tomlkit,
  wcmatch,

  # test
  gitMinimal,
  freezegun,
  pre-commit,
  pytest-cov,
  pytest-localserver,
  pytest-mock,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "bump-my-version";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "callowayproject";
    repo = "bump-my-version";
    tag = version;
    hash = "sha256-V5eFh2ne7ivtTH46QAxG0YPE0JN/W7Dt2fbf085hBVM=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    click
    httpx
    pydantic
    pydantic-settings
    questionary
    rich-click
    rich
    tomlkit
    wcmatch
  ];

  env = {
    GIT_AUTHOR_NAME = "test";
    GIT_COMMITTER_NAME = "test";
    GIT_AUTHOR_EMAIL = "test@example.com";
    GIT_COMMITTER_EMAIL = "test@example.com";
  };

  nativeCheckInputs = [
    gitMinimal
    freezegun
    pre-commit
    pytest-cov
    pytest-localserver
    pytest-mock
    pytestCheckHook
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "bumpversion" ];

  meta = {
    description = "Small command line tool to update version";
    longDescription = ''
      This is a maintained refactor of the bump2version fork of the
      excellent bumpversion project. This is a small command line tool to
      simplify releasing software by updating all version strings in your source code
      by the correct increment and optionally commit and tag the changes.
    '';
    homepage = "https://github.com/callowayproject/bump-my-version";
    changelog = "https://github.com/callowayproject/bump-my-version/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daspk04 ];
    mainProgram = "bump-my-version";
  };
}
