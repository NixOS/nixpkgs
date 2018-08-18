{ stdenv, buildPythonPackage, fetchPypi
, numpy }:

buildPythonPackage rec {
  pname = "emcee";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b83551e342b37311897906b3b8acf32979f4c5542e0a25786ada862d26241172";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "Kick ass affine-invariant ensemble MCMC sampling";
    homepage = http://dan.iel.fm/emcee;
    license = licenses.mit;
  };
}
