{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "posix_ipc";
  version = "1.1.1";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4kVroM+y7luhQSFFDo2CWzxKFGH8oHYSIKq2bUERy7c=";
  };

  pythonImportsCheckHook = [ "posix_ipc" ];

  meta = with lib; {
    description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
    homepage = "https://github.com/osvenskan/posix_ipc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
