{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "posix-ipc";
  version = "1.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "osvenskan";
    repo = "posix_ipc";
    rev = "rel${version}";
    hash = "sha256-Ehhk+IM3gTW6t6Cvc9AVAB9bscC0CMc6wQFgrZuCPz0=";
  };

  pythonImportsCheck = [ "posix_ipc" ];

  meta = {
    description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
    homepage = "https://github.com/osvenskan/posix_ipc";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
