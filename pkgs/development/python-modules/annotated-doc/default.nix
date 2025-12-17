{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "annotated-doc";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "annotated-doc";
    tag = version;
    hash = "sha256-PFB+GqFRe5vF8xoWJPsXligSpzkUIt8TOqsmrKlfwyc=";
  };

  build-system = [
    uv-build
  ];

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
  ];

  pythonImportsCheck = [
    "annotated_doc"
  ];

  meta = {
    description = "Document parameters, class attributes, return types, and variables inline, with Annotated";
    homepage = "https://github.com/fastapi/annotated-doc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
