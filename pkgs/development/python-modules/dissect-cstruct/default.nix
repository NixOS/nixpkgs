{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dissect-cstruct";
  version = "5.0.dev";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cstruct";
    tag = version;
    hash = "sha256-hoyY7Yilcv0Xl1Gv/jr158A5Y3dSmZec5Zv+/BpDn+U=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.cstruct" ];

  meta = {
    description = "Dissect module implementing a parser for C-like structures";
    homepage = "https://github.com/fox-it/dissect.cstruct";
    changelog = "https://github.com/fox-it/dissect.cstruct/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
