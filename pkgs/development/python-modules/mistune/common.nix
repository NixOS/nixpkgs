{ lib, buildPythonPackage, fetchPypi, nose, version, sha256 }:

buildPythonPackage rec {
  inherit version;
  pname = "mistune";

  src = fetchPypi {
    inherit pname version sha256;
  };

  buildInputs = [ nose ];
  pythonImportsCheck = [ "mistune" ];

  meta = with lib; {
    description = "The fastest markdown parser in pure Python";
    homepage = "https://github.com/lepture/mistune";
    license = licenses.bsd3;
  };
}
