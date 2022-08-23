{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "css-parser";
  version = "1.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25e096c63262dd249010ce36dab4cacd9595783ee09b5ed699ef12ab864ebbd1";
  };

  # Test suite not included in tarball yet
  # See https://github.com/ebook-utils/css-parser/pull/2
  doCheck = false;

  pythonImportsCheck = [
    "css_parser"
  ];

  meta = with lib; {
    description = "A CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/ebook-utils/css-parser";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jethro ];
  };
}
