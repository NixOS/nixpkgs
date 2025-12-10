{
  lib,
  stdenv,
  ansible-compat,
  ansible-core,
  buildPythonPackage,
  coreutils,
  fetchFromGitHub,
  packaging,
  pytest,
  pytest-plus,
  pytest-sugar,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-ansible";
  version = "25.12.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "pytest-ansible";
    tag = "v${version}";
    hash = "sha256-2mrz+DADelydnwNf3ytGa3igSTlybQdZ7kdlWfoG8Io=";
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
    pytest-plus
    pytest-sugar
    pytest-xdist
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

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

  meta = with lib; {
    description = "Plugin for pytest to simplify calling ansible modules from tests or fixtures";
    homepage = "https://github.com/jlaska/pytest-ansible";
    changelog = "https://github.com/ansible-community/pytest-ansible/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      robsliwi
    ];
  };
}
