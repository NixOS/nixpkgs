{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pytest-cov-stub,
  multidict,
  xmljson,
}:

buildPythonPackage (finalAttrs: {
  pname = "latex2mathml";
  version = "3.79.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = "latex2mathml";
    tag = finalAttrs.version;
    hash = "sha256-/ixS6TlovxOZgBqDq1t6KzcG6EKBSYwf3c+drHjQec4=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    multidict
    xmljson
  ];

  pythonImportsCheck = [ "latex2mathml" ];

  meta = {
    description = "Pure Python library for LaTeX to MathML conversion";
    homepage = "https://github.com/roniemartinez/latex2mathml";
    changelog = "https://github.com/roniemartinez/latex2mathml/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "latex2mathml";
    maintainers = with lib.maintainers; [ sfrijters ];
  };
})
