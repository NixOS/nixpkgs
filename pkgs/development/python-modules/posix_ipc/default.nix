{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "posix_ipc";
  version = "1.1.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+GoVsys4Vzx44wXr2RANgZij2frMA/+v457cNYM3OOM=";
  };

  pythonImportsCheckHook = [ "posix_ipc" ];

  meta = with lib; {
    description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
    homepage = "https://github.com/osvenskan/posix_ipc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
