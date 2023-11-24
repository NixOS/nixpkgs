{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, setuptools-scm
, ansible-core
, paramiko
, pytestCheckHook
, pytest-xdist
, pywinrm
, salt
}:

buildPythonPackage rec {
  pname = "pytest-testinfra";
  version = "9.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UxGzaeBUaSD85GTDv5RbVevnWhJ1aPbWFelLiJE0AUk=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    ansible-core
    paramiko
    pytestCheckHook
    pytest-xdist
    pywinrm
    salt
  ];

  # markers don't get added when docker is not available (leads to warnings):
  # https://github.com/pytest-dev/pytest-testinfra/blob/9.0.0/test/conftest.py#L223
  preCheck = ''
    export HOME=$(mktemp -d)
    sed -i '54imarkers = \
    \ttestinfra_hosts(host_selector): mark test to run on selected hosts \
    \tdestructive: mark test as destructive \
    \tskip_wsl: skip test on WSL, no systemd support' setup.cfg
  '';

  # docker is required for all disabled tests
  disabledTests = [
    # test/test_backends.py
    "test_command"
    "test_encoding"
    "test_ansible_any_error_fatal"
    "test_user_connection"
    "test_sudo"
    "test_docker_encoding"
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    # broken because salt package only built for python 3.10
    "test_backend_importables"
  ];

  disabledTestPaths = [
    "test/test_modules.py"
  ];

  meta = with lib; {
    description = "Pytest plugin for testing your infrastructure";
    homepage = "https://github.com/pytest-dev/pytest-testinfra";
    license = licenses.asl20;
    maintainers = with maintainers; [ hulr ];
  };
}
