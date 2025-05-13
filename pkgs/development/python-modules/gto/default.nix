{
  lib,
  buildPythonPackage,
  cacert,
  entrypoints,
  fetchFromGitHub,
  freezegun,
  funcy,
  pydantic,
  pytest-cov-stub,
  pytest-mock,
  pytest-test-utils,
  pytestCheckHook,
  gitMinimal,
  gitSetupHook,
  writableTmpDirAsHomeHook,
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

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "gto";
    tag = version;
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
    gitMinimal
    pytest-cov-stub
    pytest-mock
    pytest-test-utils
    pytestCheckHook
    gitSetupHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # _pygit2.GitError: OpenSSL error: failed to load certificates: error:00000000:lib(0)::reason(0)
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  disabledTests = [
    # Tests want to with a remote repo
    "remote_repo"
    "remote_git_repo"
    "test_action_doesnt_push_even_if_repo_has_remotes_set"
  ];

  pythonImportsCheck = [ "gto" ];

  meta = {
    description = "Module for Git Tag Operations";
    homepage = "https://github.com/iterative/gto";
    changelog = "https://github.com/iterative/gto/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gto";
  };
}
