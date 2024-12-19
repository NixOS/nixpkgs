{
  lib,
  buildPythonPackage,
  entrypoints,
  fastentrypoints,
  fetchFromGitHub,
  freezegun,
  funcy,
  git,
  pydantic,
  pytest-cov-stub,
  pytest-mock,
  pytest-test-utils,
  pytestCheckHook,
  pythonOlder,
  rich,
  ruamel-yaml,
  scmrepo,
  semver,
  setuptools-scm,
  setuptools,
  tabulate,
  typer,
}:

buildPythonPackage rec {
  pname = "gto";
  version = "1.7.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "gto";
    rev = "refs/tags/${version}";
    hash = "sha256-8ht22RqiGWqDoBrZnX5p3KKOLVPRm1a54962qKlTK4Q=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    entrypoints
    funcy
    pydantic
    rich
    ruamel-yaml
    scmrepo
    semver
    tabulate
    typer
  ];

  nativeCheckInputs = [
    freezegun
    git
    pytest-cov-stub
    pytest-mock
    pytest-test-utils
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)

    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"
  '';

  disabledTests = [
    # Tests want to with a remote repo
    "remote_repo"
    "remote_git_repo"
    "test_action_doesnt_push_even_if_repo_has_remotes_set"
  ];

  pythonImportsCheck = [ "gto" ];

  meta = with lib; {
    description = "Module for Git Tag Operations";
    homepage = "https://github.com/iterative/gto";
    changelog = "https://github.com/iterative/gto/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gto";
  };
}
