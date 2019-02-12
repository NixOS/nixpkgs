{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "posix_ipc";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff6c9077633fc62a491d6997c43b094d885bb45a7ca1f36c9a0d647c54b74b14";
  };

  meta = with stdenv.lib; {
    description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
    license = licenses.bsd3;
    homepage = http://semanchuk.com/philip/posix_ipc/;
  };

}
