{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "posix-ipc";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "osvenskan";
    repo = "posix_ipc";
    rev = "rel${version}";
    hash = "sha256-xK5CkThqVFVMIxBtgUfHIRNRfmBxKa/DWBYQg7QHl/M=";
  };

  pythonImportsCheck = [
    "posix_ipc"
  ];

  meta = with lib; {
    description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
    homepage = "https://github.com/osvenskan/posix_ipc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
