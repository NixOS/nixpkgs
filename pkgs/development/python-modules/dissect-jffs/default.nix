{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dissect-jffs";
  version = "1.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.jffs";
    tag = version;
    hash = "sha256-HXGmZZd+fYnOCEpffdZe9dOLJS3jY7dIrb6rmhgbYyw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
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
