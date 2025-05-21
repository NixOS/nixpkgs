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
  pname = "dissect-archive";
  version = "1.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.archive";
    tag = version;
    hash = "sha256-WqzZmt95NJPX0+wGyvJZzoOJTR5qH0YYOTFsYIihE1Y=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  pythonImportsCheck = [ "dissect.archive" ];

  meta = with lib; {
    description = "Dissect module implementing parsers for various archive and backup formats";
    homepage = "https://github.com/fox-it/dissect.archive";
    changelog = "https://github.com/fox-it/dissect.archive/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
