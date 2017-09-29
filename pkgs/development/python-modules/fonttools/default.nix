{ buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.15.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8df4b605a28e313f0f9e0a79502caba4150a521347fdbafc063e52fee34912c2";
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
