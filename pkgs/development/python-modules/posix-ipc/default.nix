{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "posix-ipc";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6cddb1ce2cf4aae383f2a0079c26c69bee257fe2720f372201ef047f8ceb8b97";
  };

  meta = with lib; {
    description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
    license = licenses.bsd3;
    homepage = "http://semanchuk.com/philip/posix-ipc/";
  };

}
