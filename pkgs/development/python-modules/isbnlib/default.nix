{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.9.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a389556cc5cf82b7ad95924710101e3bd06d809d6f889a3f437975b275af944";
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
