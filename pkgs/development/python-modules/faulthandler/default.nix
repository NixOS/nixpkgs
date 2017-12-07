{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "faulthandler";
  version = "2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zywq3jaznddvqc3hnfrlv24wmpyq4xgajk9xhv6578qw1rpfj2r";
  };

  meta = {
    description = "Dump the Python traceback";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ sauyon ];
    homepage = http://faulthandler.readthedocs.io/;
  };
}
