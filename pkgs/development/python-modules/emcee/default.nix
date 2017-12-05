{ stdenv, buildPythonPackage, fetchPypi
, numpy }:

buildPythonPackage rec {
  pname = "emcee";
  version = "2.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qyafp9jfya0mkxgqfvljf0rkic5fm8nimzwadyrxyvq7nd07qaw";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "Kick ass affine-invariant ensemble MCMC sampling";
    homepage = http://dan.iel.fm/emcee;
    license = licenses.mit;
  };
}
