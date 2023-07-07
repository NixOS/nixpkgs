{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, psutil
, pytestCheckHook
, lsof
}:

buildPythonPackage rec {
  pname = "daemonocle";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "jnrbsn";
    repo = "daemonocle";
    rev = "v${version}";
    hash = "sha256-K+IqpEQ4yhfSguPPm2Ult3kGNO/9H56B+kD5ntaCZdk=";
  };

  propagatedBuildInputs = [
    click
    psutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    lsof
  ];

  # One third of the tests fail on the sandbox with
  # "psutil.NoSuchProcess: no process found with pid 0".
  disabledTests = [
    "sudo"
    "test_chrootdir_without_permission"
    "test_uid_and_gid_without_permission"
    "test_multi_daemon"
    "test_multi_daemon_action_worker_id"
    "test_exec_worker"
  ];

  pythonImportsCheck = [
    "daemonocle"
  ];

  meta = with lib; {
    description = "A Python library for creating super fancy Unix daemons";
    longDescription = ''
      daemonocle is a library for creating your own Unix-style daemons
      written in Python.  It solves many problems that other daemon
      libraries have and provides some really useful features you don't
      often see in other daemons.
    '';
    homepage = "https://github.com/jnrbsn/daemonocle";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
    platforms = platforms.unix;
  };
}
