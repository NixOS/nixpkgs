{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ky5ynb8p580y2x3vpib6yrvdjgjb0wpqmdfnq5pqi3qzjyzsqra";
  };

  checkInputs = [
    nose
    coverage
  ];

  # requires network connection
  doCheck = false;

  meta = with lib; {
    description = "Extract, clean, transform, hyphenate and metadata for ISBNs";
    homepage = "https://github.com/xlcnd/isbnlib";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
