{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "css-parser";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7ab355512ae51334ba6791a7e4d553f87bef17ba2026f1cc9bf3b17a7779d44";
  };

  # Test suite not included in tarball yet
  # See https://github.com/ebook-utils/css-parser/pull/2
  doCheck = false;

  meta = with lib; {
    description = "A CSS Cascading Style Sheets library for Python";
    homepage = https://github.com/ebook-utils/css-parser;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jethro ];
  };
}
