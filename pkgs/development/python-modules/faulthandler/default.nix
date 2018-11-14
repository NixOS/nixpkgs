{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "faulthandler";
  version = "3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83301ffab03c86b291677b64b5cec7026f412cbda5ebd27e4cb3338452c40021";
  };

  meta = {
    description = "Dump the Python traceback";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ sauyon ];
    homepage = http://faulthandler.readthedocs.io/;
  };
}
