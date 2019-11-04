{ stdenv, buildPythonPackage, fetchPypi
, numpy }:

buildPythonPackage rec {
  pname = "emcee";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01mx1w4a7j5p29a3r7ilh9la9n6gnlgwb46m439vrnfgvbvjjy9c";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "Kick ass affine-invariant ensemble MCMC sampling";
    homepage = http://dan.iel.fm/emcee;
    license = licenses.mit;
  };
}
