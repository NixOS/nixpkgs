{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.7.1";
  name = "${pname}-${version}";

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };

  src = fetchurl {
    url = "mirror://pypi/p/phonenumbers/${name}.tar.gz";
    sha256 = "1zmi2xvh6v4iyfxmrqhj2byfac9xk733w663a7phib7y6wkvqlgr";
  };
}
