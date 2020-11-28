{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "css-parser";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "665b7965bef0c9b86955be7a3383ca44e519b46affc7c6bca5002cbdbd0bf19f";
  };

  # Test suite not included in tarball yet
  # See https://github.com/ebook-utils/css-parser/pull/2
  doCheck = false;

  meta = with lib; {
    description = "A CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/ebook-utils/css-parser";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jethro ];
  };
}
