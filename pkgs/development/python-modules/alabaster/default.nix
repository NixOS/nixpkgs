{ stdenv, buildPythonPackage, fetchPypi
, pygments }:

buildPythonPackage rec {
  pname = "alabaster";
  version = "0.7.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b63b1f4dc77c074d386752ec4a8a7517600f6c0db8cd42980cae17ab7b3275d7";
  };

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/bitprophet/alabaster;
    description = "A Sphinx theme";
    license = licenses.bsd3;
  };
}
