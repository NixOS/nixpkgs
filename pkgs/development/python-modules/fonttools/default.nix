{ buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.17.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c4f26bf32cd58d5881bfe1f42e5f0a1637a58452a60ae1623999f3ae7da0e24";
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
