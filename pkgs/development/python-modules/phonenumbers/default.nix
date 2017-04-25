{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  name = "phonenumbers-8.4.0";

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };

  src = fetchurl {
    url = "mirror://pypi/p/phonenumbers/${name}.tar.gz";
    sha256 = "1c052gd7ra3v183jq2x5nwa428wxh1g3psfh0ay5jwwmcxy78vab";
  };
}
