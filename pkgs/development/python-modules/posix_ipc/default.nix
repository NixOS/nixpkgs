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
    license = licenses.bsd3;
    homepage = "http://semanchuk.com/philip/posix_ipc/";
  };
}
