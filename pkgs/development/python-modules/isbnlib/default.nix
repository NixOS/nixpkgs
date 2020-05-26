{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p7iaa6ykvhalpv09svxs50hnp25j5nv1zzp42n5r7a7rw70wlf8";
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
