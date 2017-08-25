{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.8.0";
  name = "${pname}-${version}";

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };

  src = fetchurl {
    url = "mirror://pypi/p/phonenumbers/${name}.tar.gz";
    sha256 = "f8d5eda55e2acdfeb9db9742e1207a5cfb615ad060cabccf1e06a9ed8efd1e49";
  };
}
