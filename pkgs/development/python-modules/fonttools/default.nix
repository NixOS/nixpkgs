{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, numpy
, pytest
, pytestrunner
, glibcLocales
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "4.2.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "66bb3dfe7efe5972b0145339c063ffaf9539e973f7ff8791df84366eafc65804";
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
