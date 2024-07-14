{
  lib,
  buildPythonPackage,
  fetchPypi,
  robotframework,
  paramiko,
  scp,
}:

buildPythonPackage rec {
  version = "3.8.0";
  format = "setuptools";
  pname = "robotframework-sshlibrary";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rt+KAry3NEQEz4V10K2iXWx9wvy2XeIRPE4Hxj0kRsI=";
  };

  # unit tests are impure
  doCheck = false;

  propagatedBuildInputs = [
    robotframework
    paramiko
    scp
  ];

  meta = with lib; {
    description = "SSHLibrary is a Robot Framework test library for SSH and SFTP";
    homepage = "https://github.com/robotframework/SSHLibrary";
    license = licenses.asl20;
  };
}
