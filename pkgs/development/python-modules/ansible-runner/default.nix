{ lib
, stdenv
, ansible
, buildPythonPackage
, fetchPypi
, mock
, openssh
, pexpect
, psutil
, pytest-mock
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, python-daemon
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "ansible-runner";
  version = "2.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GK/CqmMm67VmvzlhMV6ow+40m0DYUpXCFkP+9NgR/e4=";
  };

  propagatedBuildInputs = [
    ansible
    psutil
    pexpect
    python-daemon
    pyyaml
    six
  ];

  checkInputs = [
    ansible # required to place ansible CLI onto the PATH in tests
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
  '';

  disabledTests = [
    # Requires network access
    "test_callback_plugin_task_args_leak"
    "test_env_accuracy"
    # Times out on slower hardware
    "test_large_stdout_blob"
    # Failed: DID NOT RAISE <class 'RuntimeError'>
    "test_validate_pattern"
  ] ++ lib.optional stdenv.isDarwin [
    # test_process_isolation_settings is currently broken on Darwin Catalina
    # https://github.com/ansible/ansible-runner/issues/413
    "process_isolation_settings"
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
    maintainers = with maintainers; [ costrouc ];
  };
}
