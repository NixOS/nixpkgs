{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  six,
}:

buildPythonPackage rec {
  pname = "ebooklib";
  version = "0.19";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aerkalov";
    repo = "ebooklib";
    tag = "v${version}";
    hash = "sha256-al5iSw3sIIjIYRZPrYgbBQ7V324f6OTxmtrnoOHafSQ=";
  };

  propagatedBuildInputs = [
    lxml
    six
  ];

  pythonImportsCheck = [ "ebooklib" ];

  meta = with lib; {
    description = "Python E-book library for handling books in EPUB2/EPUB3  format";
    homepage = "https://github.com/aerkalov/ebooklib";
    changelog = "https://github.com/aerkalov/ebooklib/blob/${src.tag}/CHANGES.txt";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
