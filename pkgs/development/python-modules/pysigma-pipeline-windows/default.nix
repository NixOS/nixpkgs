{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysigma-pipeline-windows";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-windows";
    tag = "v${version}";
    hash = "sha256-2S4vWneBNKq/FwhDs4Iref9hvEbcqvG/MOSTMYd7crU=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.pipelines.windows" ];

  meta = {
    description = "Library to support Windows service pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-windows";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-windows/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
