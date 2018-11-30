{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "posix_ipc";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jzg66708pi5n9w07fbz6rlxx30cjds9hp2yawjjfryafh1hg4ww";
  };

  meta = with stdenv.lib; {
    description = "POSIX IPC primitives (semaphores, shared memory and message queues)";
    license = licenses.bsd3;
    homepage = http://semanchuk.com/philip/posix_ipc/;
  };

}
