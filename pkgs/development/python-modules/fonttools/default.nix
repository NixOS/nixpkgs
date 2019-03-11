{ buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
, glibcLocales
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.38.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12ripk3s7skgxr1bs9r8n13r94ym3s8iir7ivfixls9fa4dabmlh";
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
