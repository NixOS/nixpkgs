{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "mistune";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc10c33bfdcaa4e749b779f62f60d6e12f8215c46a292d05e486b869ae306619";
  };

  buildInputs = [ nose ];

  meta = with lib; {
    description = "The fastest markdown parser in pure Python";
    homepage = https://github.com/lepture/mistune;
    license = licenses.bsd3;
  };
}
