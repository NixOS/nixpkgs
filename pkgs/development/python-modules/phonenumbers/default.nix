{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.5.0";
  name = "${pname}-${version}";

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };

  src = fetchurl {
    url = "mirror://pypi/p/phonenumbers/${name}.tar.gz";
    sha256 = "6d3d82a3dcb0418431099d1b1c24efb280cbec8f81c7ce3d1abf417c238b8859";
  };
}
