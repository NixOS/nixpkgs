{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  six,
}:

buildPythonPackage rec {
  pname = "ebooklib";
  version = "0.18";
  format = "setuptools";

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

  pythonImportsCheck = [ "ebooklib" ];

  meta = {
    description = "Python E-book library for handling books in EPUB2/EPUB3  format";
    homepage = "https://github.com/aerkalov/ebooklib";
    changelog = "https://github.com/aerkalov/ebooklib/blob/${src.rev}/CHANGES.txt";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}
