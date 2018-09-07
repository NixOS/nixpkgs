{ buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
, glibcLocales
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.29.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aab38c8c131670684321437d4857dcb4de1c775efd152a9ca9c4d81f1cb97fe7";
    extension = "zip";
  };

  buildInputs = [
    numpy
  ];

  checkInputs = [
    pytest
    pytestrunner
    glibcLocales
  ];

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  meta = {
    homepage = https://github.com/fonttools/fonttools;
    description = "A library to manipulate font files from Python";
  };
}
