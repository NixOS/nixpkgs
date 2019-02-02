{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "isbnlib";
  version = "3.9.4";

  # PyPI tarball is missing LICENSE file
  # See https://github.com/xlcnd/isbnlib/pull/53
  src = fetchFromGitHub {
    owner = "xlcnd";
    repo = "isbnlib";
    rev = "v${version}";
    sha256 = "0gc0k5khf34b4zz56a9zc3rscdhj3bx849lbzgmzpji30sbyy1fh";
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
