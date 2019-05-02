{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4ae098cb31d6c678a6eac074a24f8ba4adfe7df65db13b0b2ab7355f28d6e3b";
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
