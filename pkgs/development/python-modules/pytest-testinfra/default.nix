{
  lib,
  ansible-core,
  buildPythonPackage,
  fetchPypi,
  paramiko,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pywinrm,
  salt,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-testinfra";
  version = "10.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qHbxRToBtY2U2dk23VA0TCwBrHiAorQdFb3yM67Zzx8=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    ansible-core
    paramiko
    pytestCheckHook
    pytest-xdist
    pywinrm
    salt
  ];

  # Markers don't get added when docker is not available (leads to warnings):
  # https://github.com/pytest-dev/pytest-testinfra/blob/9.0.0/test/conftest.py#L223
  preCheck = ''
    export HOME=$(mktemp -d)
    sed -i '54imarkers = \
    \ttestinfra_hosts(host_selector): mark test to run on selected hosts \
    \tdestructive: mark test as destructive \
    \tskip_wsl: skip test on WSL, no systemd support' setup.cfg
  '';

  disabledTests = [
    # docker is required for all disabled tests
    # test/test_backends.py
    "test_command"
    "test_encoding"
    "test_ansible_any_error_fatal"
    "test_user_connection"
    "test_sudo"
    "test_docker_encoding"
    # Broken because salt package only built for Python
    "test_backend_importables"
  ];

  disabledTestPaths = [ "test/test_modules.py" ];

  meta = with lib; {
    description = "Pytest plugin for testing your infrastructure";
    homepage = "https://github.com/pytest-dev/pytest-testinfra";
    changelog = "https://github.com/pytest-dev/pytest-testinfra/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ hulr ];
  };
}
