{ buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.13.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ded1f9a6cdd6ed19a3df05ae40066d579ffded17369b976f9e701cf31b7b1f2d";
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
    homepage = "https://github.com/fonttools/fonttools";
    description = "A library to manipulate font files from Python";
  };
}
