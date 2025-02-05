{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  gevent,
  ssh-python,
  ssh2-python,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "parallel-ssh";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "ParallelSSH";
    repo = "parallel-ssh";
    tag = version;
    hash = "sha256-J/rwlJ9BOcENngIVz5cU+uA34hEEw7QsgsPnpNbbZbk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gevent
    ssh-python
    ssh2-python
  ];

  pythonImportsCheck = [ "pssh" ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  meta = {
    description = "Asynchronous parallel SSH client library";
    homepage = "https://github.com/ParallelSSH/parallel-ssh";
    changelog = "https://github.com/ParallelSSH/parallel-ssh/blob/${version}/Changelog.rst";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
