{ lib, stdenv
, buildPythonPackage
, fetchPypi
, robotframework
, paramiko
, scp
}:

buildPythonPackage rec {
  version = "3.5.1";
  pname = "robotframework-sshlibrary";

  src = fetchPypi {
    inherit pname version;
    sha256 = "843af44722d1d4e39f616e5441d6f49e82202cd1a8cc9d16637a6475a8ecb023";
  };

  # unit tests are impure
  doCheck = false;

  propagatedBuildInputs = [ robotframework paramiko scp ];

  meta = with lib; {
    description = "SSHLibrary is a Robot Framework test library for SSH and SFTP";
    homepage = "https://github.com/robotframework/SSHLibrary";
    license = licenses.asl20;
  };

}
