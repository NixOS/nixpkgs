{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dissect-database";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.database";
    tag = version;
    hash = "sha256-ZMiYPAiumPg9nd7+OAnrVAwrnx0I5reClRgIerStpfE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  # Test files are not ready
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.database" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for various database formats";
    homepage = "https://github.com/fox-it/dissect.database";
    changelog = "https://github.com/fox-it/dissect.database/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
