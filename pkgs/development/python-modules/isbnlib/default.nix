{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  coverage,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lvkIZMd7AfVfoR5b/Kn9kJUB2YQvO8cQ1Oq4UZXZBTk=";
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
    changelog = "https://github.com/xlcnd/isbnlib/blob/v${version}/CHANGES.txt";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
