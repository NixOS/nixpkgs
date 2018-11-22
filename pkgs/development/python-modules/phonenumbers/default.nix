{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06nj00qlw2qx5wvwvg32izxq461lyrkif23giixaw2xmzzddzy0l";
  };

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = https://github.com/daviddrysdale/python-phonenumbers;
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };
}
