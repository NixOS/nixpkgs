{ lib
, stdenv
, ansible-core
, buildPythonPackage
, fetchPypi
, fetchpatch
, glibcLocales
, importlib-metadata
, mock
, openssh
, pbr
, pexpect
, psutil
, pytest-mock
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, pythonOlder
, python-daemon
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "ansible-runner";
  version = "2.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eaG9E02BPI6jdAWZxv2WGhFCXOd1fy/XJc9W1qGnI2w=";
  };

  patches = [
    (fetchpatch {
      name = "fix-tests.patch";
      url = "https://github.com/ansible/ansible-runner/commit/0d522c90cfc1f305e118705a1b3335ccb9c1633d.patch";
      hash = "sha256-eTnQkftvjK0YHU+ovotRVSuVlvaVeXp5SvYk1DPCg88=";
      excludes = [ ".github/workflows/ci.yml" "tox.ini" ];
    })
  ];

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    ansible-core
    psutil
    pexpect
    python-daemon
    pyyaml
    six
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    ansible-core # required to place ansible CLI onto the PATH in tests
    glibcLocales
    pytestCheckHook
    pytest-mock
    pytest-timeout
    pytest-xdist
    mock
    openssh
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH="$PATH:$out/bin";
    # avoid coverage flags
    rm pytest.ini
  '';

  disabledTests = [
    # Requires network access
    "test_callback_plugin_task_args_leak"
    "test_env_accuracy"
    # Times out on slower hardware
    "test_large_stdout_blob"
    # Failed: DID NOT RAISE <class 'RuntimeError'>
    "test_validate_pattern"
  ];

  disabledTestPaths = [
    # These tests unset PATH and then run executables like `bash` (see https://github.com/ansible/ansible-runner/pull/918)
    "test/integration/test_runner.py"
    "test/unit/test_runner.py"
  ]
  ++ lib.optionals stdenv.isDarwin [
    # Integration tests on Darwin are not regularly passing in ansible-runner's own CI
    "test/integration"
    # These tests write to `/tmp` which is not writable on Darwin
    "test/unit/config/test__base.py"
  ];

  pythonImportsCheck = [
    "ansible_runner"
  ];

  meta = with lib; {
    description = "Helps when interfacing with Ansible";
    homepage = "https://github.com/ansible/ansible-runner";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
