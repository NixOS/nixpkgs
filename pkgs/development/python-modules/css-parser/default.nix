{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "css-parser";
  version = "1.0.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GW24Is7yJ0WvaljRgM+CBpSc7Vi0j18+6Y8d4WJ0lbs=";
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
