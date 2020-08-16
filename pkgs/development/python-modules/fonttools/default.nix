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
  version = "4.13.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "63987cd374c39a75146748f8be8637634221e53fef15cdf76f17777676d8545a";
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
