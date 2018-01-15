{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "faulthandler";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "acc10e10909f0f956ba1b42b6c450ea0bdaaa27b3942899f65931396cfcdd36a";
  };

  meta = {
    description = "Dump the Python traceback";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ sauyon ];
    homepage = http://faulthandler.readthedocs.io/;
  };
}
