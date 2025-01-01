{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysigma-pipeline-crowdstrike";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-crowdstrike";
    rev = "refs/tags/v${version}";
    hash = "sha256-9rYTBMVb664R9heOw/N/PUFotwOP1avdPUjPDhICkVU=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.pipelines.crowdstrike" ];

  disabledTests = [
    # Windows binary not mocked
    "test_crowdstrike_pipeline_parentimage"
  ];

  meta = with lib; {
    description = "Library to support CrowdStrike pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
