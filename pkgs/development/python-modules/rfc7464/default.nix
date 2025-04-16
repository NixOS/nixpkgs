{
  buildPythonPackage,
  fetchPypi,
  lib,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "rfc7464";
  version = "17.7.0";
  format = "setuptools";

  # AttributeError: module 'configparser' has no attribute 'SafeConfigParser'. Did you mean: 'RawConfigParser'?
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hcn6h38qplfcmq392cs58r01k16k202bqyap4br02376pr4ik7a";
    extension = "zip";
  };

  meta = with lib; {
    homepage = "https://github.com/moshez/rfc7464";
    description = "RFC 7464 is a proposed standard for streaming JSON documents";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ shlevy ];
  };
}
