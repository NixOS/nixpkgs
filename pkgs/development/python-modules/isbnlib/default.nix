{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2295c01465fe19776b1f9432fd99fd24e61230d146ded2752e0d980ef6f4101f";
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
