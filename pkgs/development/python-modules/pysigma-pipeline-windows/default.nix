{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysigma-pipeline-windows";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-windows";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hd4Gk8b5IAHaOdBVNLNYGXhuuT8oXVC/r/VyuH8vD2U=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.pipelines.windows" ];

  meta = {
    description = "Library to support Windows service pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-windows";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-windows/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
