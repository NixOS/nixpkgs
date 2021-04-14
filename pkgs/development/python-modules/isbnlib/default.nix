{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gbMxV9qOLCpIH3rUceG1ds9ZUpjwOv1gyYL3GLkS3Ik=";
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
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
