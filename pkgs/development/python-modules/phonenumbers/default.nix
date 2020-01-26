{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0j73mr3d3rf2r4nkaxbvl7323xima0l95pjagjzgk2piqwa3nbd2";
  };

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = https://github.com/daviddrysdale/python-phonenumbers;
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };
}
