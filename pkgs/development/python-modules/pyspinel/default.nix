{ buildPythonPackage, fetchPypi, lib, future, pyserial, ipaddress }:

buildPythonPackage rec {
  pname = "pyspinel";
  version = "1.0.0a3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0914a662d57a14bce9df21f22711b5c9b2fef37cf461be54ed35c6e229060fd4";
  };

  propagatedBuildInputs = [ pyserial ipaddress future ];

  doCheck = false;

  meta = {
    description = "Interface to the OpenThread Network Co-Processor (NCP)";
    homepage = "https://github.com/openthread/pyspinel";
    maintainers = with lib.maintainers; [ gebner ];
  };
}
