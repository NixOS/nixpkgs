{
  lib,
  ansible-core,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  paramiko,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pywinrm,
  salt,
}:

buildPythonPackage rec {
  pname = "pytest-testinfra";
  version = "10.2.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "pytest_testinfra";
    inherit version;
    hash = "sha256-U3/V64jaYYwfRhJIqiBZTPjURRLoUZsjmDfoOHXh6c0=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    ansible-core
    paramiko
    pytestCheckHook
    pytest-xdist
    pywinrm
    salt
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
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
