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
  version = "3.41.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f3q9sadwy6krsjicrgjsl1w2dfd97j4l645lnl1f5y3y1jkj4fh";
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
