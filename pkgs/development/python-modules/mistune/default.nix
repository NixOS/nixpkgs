{ lib
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "mistune";
  version = "0.7.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0byj9jg9ly7karf5sb1aqcw7avaim9sxl8ws7yw7p1fibjgsy5w5";
  };

  buildInputs = [ nose ];

  meta = with lib; {
    description = "The fastest markdown parser in pure Python";
    homepage = https://github.com/lepture/mistune;
    license = licenses.bsd3;
  };
}
