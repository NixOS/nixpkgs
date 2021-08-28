{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6kBu8uFDiKs5ZJXw9gTS08lstaJWuWvAVW3Ycc19x7Q=";
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
