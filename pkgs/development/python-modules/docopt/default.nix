{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "docopt";
  version = "0.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14f4hn6d1j4b99svwbaji8n2zj58qicyz19mm0x6pmhb50jsics9";
  };

<<<<<<< HEAD
  meta = {
    description = "Pythonic argument parser, that will make you smile";
    homepage = "http://docopt.org/";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Pythonic argument parser, that will make you smile";
    homepage = "http://docopt.org/";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
