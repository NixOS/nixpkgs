{
  lib,
  buildPythonPackage,
  cacert,
  entrypoints,
  fetchFromGitHub,
  freezegun,
  funcy,
  gitSetupHook,
  pydantic,
  pydantic-settings,
  pytest-cov-stub,
  pytest-mock,
  pytest-test-utils,
  pytestCheckHook,
  rich,
  ruamel-yaml,
  scmrepo,
  semver,
  setuptools-scm,
  setuptools,
  tabulate,
  typer,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "gto";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "gto";
    tag = finalAttrs.version;
    hash = "sha256-LXYpOnk9W/ellG70qZLihmvk4kvVcwZfE5buPNU2qzQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    entrypoints
    funcy
    pydantic
    pydantic-settings
    rich
    ruamel-yaml
    scmrepo
    semver
    tabulate
    typer
  ];

  nativeCheckInputs = [
    freezegun
    gitSetupHook
    pytest-cov-stub
    pytest-mock
    pytest-test-utils
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # _pygit2.GitError: OpenSSL error: failed to load certificates: error:00000000:lib(0)::reason(0)
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  disabledTests = [
    # Tests want to do it with a remote repo
    "remote_repo"
    "remote_git_repo"
    "test_action_doesnt_push_even_if_repo_has_remotes_set"
    "test_api"
    # ValueError: stderr not separately captured
    "test_register"
    "test_assign"
    "test_stderr_gto_exception"
    "test_stderr_exception"
  ];

  pythonImportsCheck = [ "gto" ];

  meta = {
    description = "Module for Git Tag Operations";
    homepage = "https://github.com/iterative/gto";
    changelog = "https://github.com/iterative/gto/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gto";
  };
})
