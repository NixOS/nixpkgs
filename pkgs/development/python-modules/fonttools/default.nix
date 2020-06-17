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
  version = "4.2.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f05bff703e31d5f28e713afe89aed0e6649b02c09d8df958e8a02df9c9b2fc0e";
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
    homepage = "https://github.com/fonttools/fonttools";
    description = "A library to manipulate font files from Python";
    license = lib.licenses.mit;
  };
}
