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
  version = "2.14.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ParallelSSH";
    repo = "parallel-ssh";
    tag = version;
    hash = "sha256-TeNQitaNVbK96Aui8OcKin2sHpF8VlMQmb5ODT2lQh4=";
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
    changelog = "https://github.com/ParallelSSH/parallel-ssh/blob/${src.tag}/Changelog.rst";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ infinidoge ];
  };
}
