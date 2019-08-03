{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "docopt";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14f4hn6d1j4b99svwbaji8n2zj58qicyz19mm0x6pmhb50jsics9";
  };

  meta = with stdenv.lib; {
    description = "Pythonic argument parser, that will make you smile";
    homepage = http://docopt.org/;
    license = licenses.mit;
  };
}
