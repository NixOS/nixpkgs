{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-insightidr";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-insightidr";
    tag = "v${version}";
    hash = "sha256-dc25zDYQeU9W9qwrRz7zsM2wOl8kMapDvwFhB6VOwhY=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  pythonRelaxDeps = [ "pysigma" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "sigma.backends.insight_idr"
    "sigma.pipelines.insight_idr"
  ];

  meta = {
    description = "Library to support the Rapid7 InsightIDR backend for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-insightidr";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-insightidr/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
