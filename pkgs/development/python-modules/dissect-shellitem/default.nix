{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dissect-shellitem";
  version = "3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.shellitem";
    tag = version;
    hash = "sha256-2pgKfvlYt8eZh6YsTx6Gqd0XvvzJtaSh0tnhVF+Z/50=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.shellitem" ];

  # Windows-specific tests
  doCheck = false;

  meta = with lib; {
    description = "Dissect module implementing a parser for the Shellitem structures";
    homepage = "https://github.com/fox-it/dissect.shellitem";
    changelog = "https://github.com/fox-it/dissect.shellitem/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "parse-lnk";
  };
}
