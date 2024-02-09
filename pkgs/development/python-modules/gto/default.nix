{ lib
, buildPythonPackage
, entrypoints
, fastentrypoints
, fetchFromGitHub
, freezegun
, funcy
, git
, pydantic
, pytest-mock
, pytest-test-utils
, pytestCheckHook
, pythonOlder
, rich
, ruamel-yaml
, scmrepo
, semver
, setuptools
, setuptools-scm
, tabulate
, typer
}:

buildPythonPackage rec {
  pname = "gto";
  version = "1.6.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "gto";
    rev = "refs/tags/${version}";
    hash = "sha256-1+Owhp2otGC/FIdsSz+4vn0sZR696+zOMGNDvjM6KH8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace ', "setuptools_scm_git_archive==1.4.1"' ""
    substituteInPlace setup.cfg \
      --replace " --cov=gto --cov-report=term-missing --cov-report=xml" ""
  '';

  nativeBuildInputs = [
    fastentrypoints
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "gto"
  ];

  meta = with lib; {
    description = "Module for Git Tag Operations";
    homepage = "https://github.com/iterative/gto";
    changelog = "https://github.com/iterative/gto/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
