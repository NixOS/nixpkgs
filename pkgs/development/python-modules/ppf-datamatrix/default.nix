{
  lib,
  buildPythonPackage,
  setuptools-scm,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ppf-datamatrix";
  version = "0.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "adrianschlatter";
    repo = "ppf.datamatrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g6KTUUYDXUlFmV0Rg3Mp23huAb+j+LTWrvY8wuYB90g=";
  };

  build-system = [ setuptools-scm ];

  pythonImportsCheck = [ "ppf.datamatrix" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Pure-python package to generate data matrix codes";
    homepage = "https://github.com/adrianschlatter/ppf.datamatrix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kurogeek ];
    changelog = "https://github.com/adrianschlatter/ppf.datamatrix/releases/tag/v${finalAttrs.src.tag}";
  };
})
