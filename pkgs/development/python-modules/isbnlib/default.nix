{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FOZNsZK8PTPJhK0BvGQiPqCr8au3rwHsjE3dCKWGtDM=";
  };

  nativeCheckInputs = [
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
