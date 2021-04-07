{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b324c7c8689741bba6d71d1369d49780a24fe946b11a3c005d56e09bf705cd19";
  };

  checkInputs = [
    nose
    coverage
  ];

  # requires network connection
  doCheck = false;

  pythonImportsCheck = [ "isbnlib" ];

  meta = with lib; {
    description = "Extract, clean, transform, hyphenate and metadata for ISBNs";
    homepage = "https://github.com/xlcnd/isbnlib";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
