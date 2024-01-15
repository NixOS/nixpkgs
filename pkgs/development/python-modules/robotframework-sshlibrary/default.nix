{ lib
, buildPythonPackage
, fetchPypi
, robotframework
, paramiko
, scp
}:

buildPythonPackage rec {
  version = "3.8.0";
  format = "setuptools";
  pname = "robotframework-sshlibrary";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aedf8a02bcb7344404cf8575d0ada25d6c7dc2fcb65de2113c4e07c63d2446c2";
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
