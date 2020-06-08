{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09kww3fzn85gbj4lw8kqrppm9kq7nmy7b96p76sscamrpsdg31im";
  };

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };
}
