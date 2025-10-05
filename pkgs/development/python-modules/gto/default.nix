{
  lib,
  buildPythonPackage,
  cacert,
  entrypoints,
  fetchFromGitHub,
  freezegun,
  funcy,
  gitMinimal,
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
  version = "1.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "gto";
    tag = version;
    hash = "sha256-XgVV/WPs9QcxjVVsdvloo2+QWNViAJE404Nue7ZcBak=";
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
    gitMinimal
    pytest-cov-stub
    pytest-mock
    pytest-test-utils
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)

    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"

    # _pygit2.GitError: OpenSSL error: failed to load certificates: error:00000000:lib(0)::reason(0)
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  disabledTests = [
    # Tests want to with a remote repo
    "remote_repo"
    "remote_git_repo"
    "test_action_doesnt_push_even_if_repo_has_remotes_set"
    # ValueError: stderr not separately captured
    "test_register"
    "test_assign"
    "test_stderr_gto_exception"
    "test_stderr_exception"
  ];

  pythonImportsCheck = [ "gto" ];

  meta = with lib; {
    description = "Module for Git Tag Operations";
    homepage = "https://github.com/iterative/gto";
    changelog = "https://github.com/iterative/gto/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gto";
  };
}
