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
  version = "4.11.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7fe5937206099ef284055b8c94798782e0993a740eed87f0dd262ed9870788aa";
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
