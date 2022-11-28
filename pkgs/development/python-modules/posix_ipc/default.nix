{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "posix_ipc";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+GoVsys4Vzx44wXr2RANgZij2frMA/+v457cNYM3OOM=";
  };

  meta = with lib; {
    description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
    license = licenses.bsd3;
    homepage = "http://semanchuk.com/philip/posix_ipc/";
  };

}
