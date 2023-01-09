{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "posix-ipc";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4kVroM+y7luhQSFFDo2CWzxKFGH8oHYSIKq2bUERy7c=";
  };

  pythonImportsCheckHook = [
    "posix_ipc"
  ];

  meta = with lib; {
    description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
    homepage = "https://github.com/osvenskan/posix_ipc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
