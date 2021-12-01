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
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15j0ljgw1rjxq4xiywxxxnxj4r6vwk8dwljkdsjmq3qmwgifcswg";
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
