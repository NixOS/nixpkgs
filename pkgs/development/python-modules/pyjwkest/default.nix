{ lib, buildPythonPackage, fetchPypi,
  future, pycryptodomex, pytest, requests, six
}:

buildPythonPackage rec {
  pname = "pyjwkest";
  name = "${pname}-${version}";
  version = "1.4.0";

  meta = {
    description = "Implementation of JWT, JWS, JWE and JWK";
    homepage = https://github.com/rohe/pyjwkest;
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "128e3c81d02993ac4cd7e29ef7aac767d91daa59380e6883ae589092945e4aad";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ future pycryptodomex requests six ];
}
