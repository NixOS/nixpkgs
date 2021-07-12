{ lib
, buildPythonPackage
, fetchPypi
, robotframework
, paramiko
, scp
}:

buildPythonPackage rec {
  version = "3.6.0";
  pname = "robotframework-sshlibrary";

  src = fetchPypi {
    inherit pname version;
    sha256 = "169c343f4db71e1969169fa6f383ca7fff549aa8f83bdd3d9cbd03cea928b688";
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
