{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  setuptools,
  gevent,
  ssh-python,
  ssh2-python,
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

  meta = {
    description = "Asynchronous parallel SSH client library";
    homepage = "https://github.com/ParallelSSH/parallel-ssh";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
