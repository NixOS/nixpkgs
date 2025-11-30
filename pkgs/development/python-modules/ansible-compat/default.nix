{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  pyyaml,
  subprocess-tee,

  # tests
  coreutils,
  ansible-core,
  flaky,
  pytest-mock,
  pytest-instafail,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "ansible-compat";
  version = "25.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "ansible-compat";
    tag = "v${version}";
    hash = "sha256-hwfD7B0r8wRo/BUUA00TTQXCkrY8TAUM5BiP4Q4Atd0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    ansible-core
    pyyaml
    subprocess-tee
  ];

  nativeCheckInputs = [
    ansible-core # ansible-config
    flaky
    pytest-mock
    pytest-instafail
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    substituteInPlace test/test_runtime.py \
      --replace-fail "printenv" "${lib.getExe' coreutils "printenv"}"
  '';

  disabledTests = [
    # require network
    "test_install_collection"
    "test_install_collection_from_disk"
    "test_install_collection_git"
    "test_load_plugins"
    "test_prepare_environment_with_collections"
    "test_prerun_reqs_v1"
    "test_prerun_reqs_v2"
    "test_require_collection_install"
    "test_require_collection_no_cache_dir"
    "test_require_collection_preexisting_broken"
    "test_require_collection_not_isolated"
    "test_runtime_has_playbook"
    "test_runtime_plugins"
    "test_runtime_example"
    "test_scan_sys_path"
    "test_upgrade_collection"
    "test_ro_venv"
  ];

  pythonImportsCheck = [ "ansible_compat" ];

  meta = {
    description = "Function collection that help interacting with various versions of Ansible";
    homepage = "https://github.com/ansible/ansible-compat";
    changelog = "https://github.com/ansible/ansible-compat/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dawidd6 ];
  };
}
