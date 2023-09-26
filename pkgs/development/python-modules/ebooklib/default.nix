{ lib
, buildPythonPackage
, fetchFromGitHub

, lxml
, six
}:

buildPythonPackage rec {
  pname = "ebooklib";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "aerkalov";
    repo = "ebooklib";
    rev = "v${version}";
    hash = "sha256-Ciks/eeRpkqkWnyLgyHC+x/dSOcj/ZT45KUElKqv1F8=";
  };

  propagatedBuildInputs = [
    lxml
    six
  ];

  pythonImportsCheck = [
    "ebooklib"
  ];

  meta = with lib; {
    description = "Python E-book library for handling books in EPUB2/EPUB3 format";
    homepage = "https://ebooklib.readthedocs.io";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ paveloom ];
  };
}
