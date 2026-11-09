{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-expression-eval";
  version = "0.3.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "axiacore";
    repo = "py-expression-eval";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YxhZd8V6ofphcNdcbBbrT5mc37O9c6W1mfhsvFVC+KM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "py_expression_eval" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    homepage = "https://github.com/AxiaCore/py-expression-eval/";
    description = "Python Mathematical Expression Evaluator";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cynerd ];
  };
})
