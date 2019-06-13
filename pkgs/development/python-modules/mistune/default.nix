{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "mistune";
  version = "0.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e";
  };

  buildInputs = [ nose ];

  meta = with lib; {
    description = "The fastest markdown parser in pure Python";
    homepage = https://github.com/lepture/mistune;
    license = licenses.bsd3;
  };
}
