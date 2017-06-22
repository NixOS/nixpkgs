{ buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.13.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ec278ff231d0c88afe8266e911ee0f8e66c8501c53f5f144a1a0abbc936c6b8";
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
