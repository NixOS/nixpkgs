{ stdenv, buildPythonPackage, fetchPypi
, numpy }:

buildPythonPackage rec {
  pname = "emcee";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "353c26d8a8b09553532cd93662ddbedcd1a77feecefda5e46ea7e38829dede89";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "Kick ass affine-invariant ensemble MCMC sampling";
    homepage = http://dan.iel.fm/emcee;
    license = licenses.mit;
  };
}
