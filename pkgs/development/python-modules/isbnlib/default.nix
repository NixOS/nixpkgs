{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f500a0561b83a2982d3424d640243d05bda9716f4fe9a655e331f3a07ca02710";
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
