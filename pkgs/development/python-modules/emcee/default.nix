{ stdenv, buildPythonPackage, fetchPypi
, numpy }:

buildPythonPackage rec {
  pname = "emcee";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "035a44d7594fdd03efd10a522558cdfaa080e046ad75594d0bf2aec80ec35388";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "Kick ass affine-invariant ensemble MCMC sampling";
    homepage = "https://emcee.readthedocs.io/";
    license = licenses.mit;
  };
}
