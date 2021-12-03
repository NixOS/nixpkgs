{ lib
, buildPythonPackage
, fetchPypi
, psutil
, pexpect
, python-daemon
, pyyaml
, six
, stdenv
, ansible
, mock
, openssh
, pytest-mock
, pytest-timeout
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ansible-runner";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7684612f7543c5f07f3e8135667eeb22a9dbd98f625cc69901ba9924329ef24f";
  };

  checkInputs = [
    ansible # required to place ansible CLI onto the PATH in tests
    pytestCheckHook
    pytest-mock
    pytest-timeout
    pytest-xdist
    mock
    openssh
  ];

  propagatedBuildInputs = [
    ansible
    psutil
    pexpect
    python-daemon
    pyyaml
    six
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    "test_callback_plugin_task_args_leak" # requires internet
    "test_env_accuracy"
    "test_large_stdout_blob" # times out on slower hardware
  ]
    # test_process_isolation_settings is currently broken on Darwin Catalina
    # https://github.com/ansible/ansible-runner/issues/413
  ++ lib.optional stdenv.isDarwin "process_isolation_settings";

  disabledTestPaths = [
    # these tests unset PATH and then run executables like `bash` (see https://github.com/ansible/ansible-runner/pull/918)
    "test/integration/test_runner.py"
    "test/unit/test_runner.py"
  ]
  ++ lib.optionals stdenv.isDarwin [
    # integration tests on Darwin are not regularly passing in ansible-runner's own CI
    "test/integration"
    # these tests write to `/tmp` which is not writable on Darwin
    "test/unit/config/test__base.py"
  ];

  meta = with lib; {
    description = "Helps when interfacing with Ansible";
    homepage = "https://github.com/ansible/ansible-runner";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
