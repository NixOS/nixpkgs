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
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-windows";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9NM4wgTm4jGXCmHZk9yUzg+OXJyHU4etzz0oiAjvYeQ=";
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
