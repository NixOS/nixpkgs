{ lib
, buildPythonPackage
, fetchPypi

, absl-py
, jaxlib
, opt-einsum
}:

buildPythonPackage rec {
  pname = "jax";
  version = "0.1.70";

  src = fetchPypi {
    inherit pname version;
    sha256 = "76e653cc09166d4073cdf85afb18d33b662c0e7c344d49bdb52b5837fa01a4ad";
  };

  propagatedBuildInputs = [
    absl-py
    jaxlib
    opt-einsum
  ];

  meta = {
    description = "Differentiate, compile, and transform Numpy code";
    homepage = "https://github.com/google/jax";
    license = lib.licenses.asl20;  
  };
}