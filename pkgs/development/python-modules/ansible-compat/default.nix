{
  lib,
  buildPythonPackage,
  fetchPypi,
  ansible-core,
  coreutils,
  flaky,
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  setuptools,
  setuptools-scm,
  subprocess-tee,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ansible-compat";
  version = "24.6.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "ansible_compat";
    inherit version;
    hash = "sha256-+T1MNH2OGQPCkkSUQcCamH1wNm+crfmv5eMtyKAZPKw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyyaml
    subprocess-tee
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    substituteInPlace test/test_runtime.py \
      --replace-fail "printenv" "${coreutils}/bin/printenv"
  '';

  nativeCheckInputs = [
    ansible-core
    flaky
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # require network
    "test_prepare_environment_with_collections"
    "test_prerun_reqs_v1"
    "test_prerun_reqs_v2"
    "test_require_collection_wrong_version"
    "test_require_collection"
    "test_install_collection"
    "test_install_collection_dest"
    "test_upgrade_collection"
    "test_require_collection_no_cache_dir"
    "test_runtime_has_playbook"
    "test_runtime_plugins"
    "test_scan_sys_path"
  ];

  pythonImportsCheck = [ "ansible_compat" ];

  meta = with lib; {
    description = "Function collection that help interacting with various versions of Ansible";
    homepage = "https://github.com/ansible/ansible-compat";
    changelog = "https://github.com/ansible/ansible-compat/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dawidd6 ];
  };
}
