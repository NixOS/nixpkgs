{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb3b400b37a73cf4a0bc698be2ea414e78ff117867baed9313aa8c97596e1b98";
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
