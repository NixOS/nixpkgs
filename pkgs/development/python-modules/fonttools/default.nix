{ buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "3.21.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96b636793c806206b1925e21224f4ab2ce5bea8ae0990ed181b8ac8d30848f47";
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
