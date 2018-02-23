{ lib
, buildPythonPackage
, fetchPypi
, fetchurl
}:

buildPythonPackage rec {
  pname = "pypng";
  version = "0.0.18";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0cnrxh7m5vcv502fq7rfms0z5w50lyayrarxrgi8fccy64316nlq";
  };

  meta = with lib; {
    homepage = https://github.com/drj11/pypng;
    license = licenses.mit;
    description = "Pure Python PNG image encoder/decoder";
  };
}
