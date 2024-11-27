{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-cstruct";
  version = "4.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cstruct";
    rev = "refs/tags/${version}";
    hash = "sha256-Y6maLjugnso3cc9zyiZ/6AdrftYAAImYNBDXPJdTuWc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.cstruct" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for C-like structures";
    homepage = "https://github.com/fox-it/dissect.cstruct";
    changelog = "https://github.com/fox-it/dissect.cstruct/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
