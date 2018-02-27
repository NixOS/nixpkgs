{ buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.23.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9af97075be0395b631880a82ba88dcf694c8aa76b07a622bf5f650e8f8cff293";
    extension = "zip";
  };

  buildInputs = [
    numpy
  ];

  checkInputs = [
    pytest
    pytestrunner
  ];

  meta = {
    homepage = https://github.com/fonttools/fonttools;
    description = "A library to manipulate font files from Python";
  };
}
