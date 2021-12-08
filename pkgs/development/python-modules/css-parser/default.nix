{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "css-parser";
  version = "1.0.6";

  src = fetchFromGitHub {
     owner = "ebook-utils";
     repo = "css-parser";
     rev = "v1.0.6";
     sha256 = "0nk444f01c7c7cqc3v51698kqgijyg65mg0a882bngydzixf1qwn";
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
