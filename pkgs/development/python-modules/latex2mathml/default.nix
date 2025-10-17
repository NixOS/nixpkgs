{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-cov-stub,
  multidict,
  xmljson,
}:

buildPythonPackage rec {
  pname = "latex2mathml";
  version = "3.78.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = "latex2mathml";
    tag = version;
    hash = "sha256-VhBq6KSiomFPue9yzYhU68gH+MkHovVi8VEEFi3yUZ8=";
  };

  build-system = [ poetry-core ];

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
    changelog = "https://github.com/roniemartinez/latex2mathml/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "latex2mathml";
    maintainers = with lib.maintainers; [ sfrijters ];
  };
}
