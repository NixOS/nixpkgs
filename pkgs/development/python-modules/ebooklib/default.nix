{ lib
, buildPythonPackage
, fetchFromGitHub

# dependencies
, lxml
, six
}:

buildPythonPackage rec {
  pname = "ebooklib";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "aerkalov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-efTrImakI4ZapaxN71Wq5+a7YOFkmbz129AgcIzO5ZQ=";
  };

  propagatedBuildInputs = [
    lxml
    six
  ];

  pythonImportsCheck = [ "ebooklib" ];

  meta = with lib; {
    description = "Python E-book library for handling books in EPUB2/EPUB3 format";
    homepage = "https://github.com/aerkalov/ebooklib/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ pacien ];
  };
}
