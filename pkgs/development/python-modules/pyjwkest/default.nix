{ lib, buildPythonPackage, fetchPypi,
  future, pycryptodomex, pytest, requests, six
}:

buildPythonPackage rec {
  pname = "pyjwkest";
  version = "1.4.2";
  format = "setuptools";

  meta = {
    description = "Implementation of JWT, JWS, JWE and JWK";
    homepage = "https://github.com/rohe/pyjwkest";
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "5560fd5ba08655f29ff6ad1df1e15dc05abc9d976fcbcec8d2b5167f49b70222";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ future pycryptodomex requests six ];
}
