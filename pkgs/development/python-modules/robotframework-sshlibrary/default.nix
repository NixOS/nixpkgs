{ stdenv
, buildPythonPackage
, fetchPypi
, robotframework
, paramiko
, scp
}:

buildPythonPackage rec {
  version = "3.3.0";
  pname = "robotframework-sshlibrary";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc5b5db63cf63a937bd4ada1a8b7508ec8a75d9454fa75e6410cbe72fd718de9";
  };

  # unit tests are impure
  doCheck = false;

  propagatedBuildInputs = [ robotframework paramiko scp ];

  meta = with stdenv.lib; {
    description = "SSHLibrary is a Robot Framework test library for SSH and SFTP";
    homepage = https://github.com/robotframework/SSHLibrary;
    license = licenses.asl20;
  };

}
