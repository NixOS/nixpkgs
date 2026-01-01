{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  six,
}:

buildPythonPackage rec {
  pname = "ebooklib";
<<<<<<< HEAD
  version = "0.20";
=======
  version = "0.19";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aerkalov";
    repo = "ebooklib";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XrciVPaVU8tKhgNMJdN4uwGJT36iccyF8QMj/shSahw=";
=======
    hash = "sha256-al5iSw3sIIjIYRZPrYgbBQ7V324f6OTxmtrnoOHafSQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  propagatedBuildInputs = [
    lxml
    six
  ];

  pythonImportsCheck = [ "ebooklib" ];

<<<<<<< HEAD
  meta = {
    description = "Python E-book library for handling books in EPUB2/EPUB3  format";
    homepage = "https://github.com/aerkalov/ebooklib";
    changelog = "https://github.com/aerkalov/ebooklib/blob/${src.tag}/CHANGES.txt";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
=======
  meta = with lib; {
    description = "Python E-book library for handling books in EPUB2/EPUB3  format";
    homepage = "https://github.com/aerkalov/ebooklib";
    changelog = "https://github.com/aerkalov/ebooklib/blob/${src.tag}/CHANGES.txt";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Scrumplex ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
