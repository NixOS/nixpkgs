{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9e6c1dcaa9dff195429373cf2beb3117f30b3fca43d7db5aec5a2d1f6f59784";
  };

  checkInputs = [
    nose
    coverage
  ];

  # requires network connection
  doCheck = false;

  pythonImportsCheck = [
    "isbnlib"
    "isbnlib.config"
    "isbnlib.dev"
    "isbnlib.dev.helpers"
    "isbnlib.registry"
  ];

  meta = with lib; {
    description = "Extract, clean, transform, hyphenate and metadata for ISBNs";
    homepage = "https://github.com/xlcnd/isbnlib";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
