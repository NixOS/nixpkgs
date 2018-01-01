{ lib, buildPythonPackage, fetchPypi,
  future, pycryptodomex, pytest, requests, six
}:

buildPythonPackage rec {
  pname = "pyjwkest";
  name = "${pname}-${version}";
  version = "1.3.6";

  meta = {
    description = "Implementation of JWT, JWS, JWE and JWK";
    homepage = https://github.com/rohe/pyjwkest;
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "60e1369db5fe67014450877f9933ff587be404a2be9eebccc0cadd4ec6236f78";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ future pycryptodomex requests six ];
}
