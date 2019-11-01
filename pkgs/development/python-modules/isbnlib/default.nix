{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.9.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba2d5a86a70db0f1951df479205e9144d9e55b8af4995b3857a79a30c6ff16ab";
  };

  checkInputs = [
    nose
    coverage
  ];

  # requires network connection
  doCheck = false;

  meta = with lib; {
    description = "Extract, clean, transform, hyphenate and metadata for ISBNs";
    homepage = https://github.com/xlcnd/isbnlib;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
