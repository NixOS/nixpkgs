{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "css-parser";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ed448a8a5622edb1d30d616bbc4bd3d30f11be922343d7a92d7e418e324af2e";
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
