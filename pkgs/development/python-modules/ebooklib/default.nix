{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  six,
}:

buildPythonPackage rec {
  pname = "ebooklib";
  version = "0.21";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aerkalov";
    repo = "ebooklib";
    tag = "v${version}";
    hash = "sha256-jRieIOB1FBBzz4JNvXZE1GepJv+ZFzzD7pGLAsdeIl8=";
  };

  propagatedBuildInputs = [
    lxml
    six
  ];

  pythonImportsCheck = [ "ebooklib" ];

  meta = {
    description = "Python E-book library for handling books in EPUB2/EPUB3  format";
    homepage = "https://github.com/aerkalov/ebooklib";
    changelog = "https://github.com/aerkalov/ebooklib/blob/${src.tag}/CHANGES.txt";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}
