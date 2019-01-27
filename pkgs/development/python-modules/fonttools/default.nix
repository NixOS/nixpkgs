{ buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
, glibcLocales
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.36.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1665w0xcl1x4zzhh7ssh7v9zw6nl9m7f7ji3bqs29vc4vb381qlg";
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
