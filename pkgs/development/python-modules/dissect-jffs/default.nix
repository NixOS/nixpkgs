{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dissect-jffs";
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.jffs";
    tag = version;
    hash = "sha256-yzEaOVP4QOQD24cxy+GKS0mQRvYD4GcPwYydwrzFqXs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  pythonImportsCheck = [ "dissect.jffs" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for the JFFS2 file system";
    homepage = "https://github.com/fox-it/dissect.jffs";
    changelog = "https://github.com/fox-it/dissect.jffs/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
