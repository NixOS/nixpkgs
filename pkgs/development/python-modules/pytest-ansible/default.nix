{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, ansible-core
, coreutils
, coverage
, pytest
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "pytest-ansible";
  version = "3.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-fSerRbd7QeEdTfyy2lVLq7FKHWWT0MlutonunHhM5M4=";
  };

  postPatch = ''
    substituteInPlace tests/conftest.py inventory \
      --replace '/usr/bin/env' '${coreutils}/bin/env'
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    ansible-core
  ];

  nativeCheckInputs = [
    coverage
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTests = [
    # Host unreachable in the inventory
    "test_become"
    # [Errno -3] Temporary failure in name resolution
    "test_connection_failure_v2"
    "test_connection_failure_extra_inventory_v2"
  ] ++ lib.optionals stdenv.isDarwin [
    # These tests fail in the Darwin sandbox
    "test_ansible_facts"
    "test_func"
    "test_param_override_with_marker"
  ];

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # These tests fail in the Darwin sandbox
    "tests/test_adhoc.py"
    "tests/test_adhoc_result.py"
  ];

  pythonImportsCheck = [
    "pytest_ansible"
  ];

  meta = with lib; {
    description = "Plugin for py.test to simplify calling ansible modules from tests or fixtures";
    homepage = "https://github.com/jlaska/pytest-ansible";
    changelog = "https://github.com/ansible-community/pytest-ansible/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ tjni ];
  };
}
