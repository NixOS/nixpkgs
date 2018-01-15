{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.8.8";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff2f492e49c212bb7185954efe09e68583a67daec586c02c49bc728c343d4eb0";
  };

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = https://github.com/daviddrysdale/python-phonenumbers;
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };
}
