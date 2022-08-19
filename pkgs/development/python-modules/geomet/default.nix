{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, six
}:

buildPythonPackage rec {
  pname = "geomet";
  version = "0.3.1";

  # pypi tarball doesn't include tests
  src = fetchFromGitHub {
    owner = "geomet";
    repo = "geomet";
    rev = "refs/tags/${version}";
    sha256 = "sha256-7QfvGQlg4nTr1rwTyvTNm6n/jFptLtpBKMjjQj6OXCQ=";
  };

  propagatedBuildInputs = [ click six ];

  meta = with lib; {
    homepage = "https://github.com/geomet/geomet";
    license = licenses.asl20;
    description = "Convert GeoJSON to WKT/WKB (Well-Known Text/Binary), and vice versa.";
    maintainers = with maintainers; [ turion ris ];
  };
}
