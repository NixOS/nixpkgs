{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  coreutils,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  ansible-compat,
  ansible-core,
  packaging,
  pytest-xdist,

  # buildInputs
  pytest,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-ansible";
  version = "26.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "pytest-ansible";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3pppBAgAfkwJNPRsI6CH4UDMqyZ45+mFNejlQwX5bCg=";
  };

  postPatch = ''
    substituteInPlace inventory \
      --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [
    ansible-core
    ansible-compat
    packaging
    pytest-xdist
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  enabledTestPaths = [ "tests/" ];

  disabledTests = [
    # pytest unrecognized arguments in test_pool.py
    "test_ansible_test"
    # Host unreachable in the inventory
    "test_become"
    # [Errno -3] Temporary failure in name resolution
    "test_connection_failure_v2"
    "test_connection_failure_extra_inventory_v2"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # These tests fail in the Darwin sandbox
    "test_ansible_facts"
    "test_func"
    "test_param_override_with_marker"
  ];

  disabledTestPaths = [
    # Test want s to execute pytest in a subprocess
    "tests/integration/test_molecule.py"

    # TypeError: Cannot define type '_AnsibleLazyTemplateDict' since '_AnsibleLazyTemplateDict'
    # already extends '_AnsibleTaggedDict'.
    "tests/test_host_manager.py"

    # assert <ExitCode.TESTS_FAILED: 1> == <ExitCode.OK: 0>
    "tests/test_fixtures.py"
    "tests/test_params.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # These tests fail in the Darwin sandbox
    "tests/test_adhoc.py"
    "tests/test_adhoc_result.py"
  ]
  ++ lib.optionals (lib.versionAtLeast ansible-core.version "2.16") [
    # Test fail in the NixOS environment
    "tests/test_adhoc.py"
  ];

  pythonImportsCheck = [ "pytest_ansible" ];

  meta = {
    description = "Plugin for pytest to simplify calling ansible modules from tests or fixtures";
    homepage = "https://github.com/jlaska/pytest-ansible";
    changelog = "https://github.com/ansible-community/pytest-ansible/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      robsliwi
    ];
  };
})
