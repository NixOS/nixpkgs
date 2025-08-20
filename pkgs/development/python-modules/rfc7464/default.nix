{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "rfc7464";
  version = "17.7.0";
  format = "setuptools";

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
