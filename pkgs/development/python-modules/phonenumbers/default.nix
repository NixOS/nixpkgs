{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "phonenumbers";
  version = "8.12.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "70aa98a50ba7bc7f6bf17851f806c927107e7c44e7d21eb46bdbec07b99d23ae";
  };

  meta = {
    description = "Python version of Google's common library for parsing, formatting, storing and validating international phone numbers";
    homepage    = "https://github.com/daviddrysdale/python-phonenumbers";
    license     = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ fadenb ];
  };
}
