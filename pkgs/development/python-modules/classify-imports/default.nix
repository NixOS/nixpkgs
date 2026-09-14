{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "classify-imports";
  version = "4.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "classify-imports";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ae2z1AARVMS0OgkmqPSm9BYu2WHNOB/iVhq9b4qEPPM=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "classify_imports" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Utilities for refactoring imports in python-like syntax";
    homepage = "https://github.com/asottile/classify-imports";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
})
