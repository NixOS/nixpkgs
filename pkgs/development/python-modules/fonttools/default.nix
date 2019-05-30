{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
, glibcLocales
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.42.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w0ncs61821bnc2smfllnhfw5b8fwz972yqcgb64lr5qiwxkj2y0";
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
    license = lib.licenses.mit;
  };
}
