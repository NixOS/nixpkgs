{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.9.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c60423cdd0eee3a65dd2d8280fab08e4d9fa4675dce1651c164a6408fecacfc";
  };

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = https://github.com/daviddrysdale/python-phonenumbers;
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };
}
