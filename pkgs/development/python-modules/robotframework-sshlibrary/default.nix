{ lib
, buildPythonPackage
, fetchPypi
, robotframework
, paramiko
, scp
}:

buildPythonPackage rec {
  version = "3.7.0";
  pname = "robotframework-sshlibrary";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55bd5a11bb1fe60a5a83446e6a3e1e81b13fc671e3b660aa55912a263c1f63aa";
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
