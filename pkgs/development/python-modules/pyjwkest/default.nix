{ lib, buildPythonPackage, fetchPypi,
  future, pycryptodomex, pytest, requests, six
}:

buildPythonPackage rec {
  pname = "pyjwkest";
  name = "${pname}-${version}";
  version = "1.3.2";

  meta = {
    description = "Implementation of JWT, JWS, JWE and JWK";
    homepage = https://github.com/rohe/pyjwkest;
    license = lib.licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "11rrswsmma3wzi2qnmq929323yc6i9fkjsv8zr7b3vajd72yr49d";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ future pycryptodomex requests six ];
}
