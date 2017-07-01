{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.5.1";
  name = "${pname}-${version}";

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };

  src = fetchurl {
    url = "mirror://pypi/p/phonenumbers/${name}.tar.gz";
    sha256 = "b7d1a5832650fad633d1e4159873788ebfb15e053292c20ab9f5119a574f3a67";
  };
}
