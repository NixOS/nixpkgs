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
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-crowdstrike";
    rev = "refs/tags/v${version}";
    hash = "sha256-0uSoZC2cUgdOGE5saLlx5n0gbVPX61kkASCBFD4F5QM=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ pysigma ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.pipelines.crowdstrike" ];

  meta = with lib; {
    description = "Library to support CrowdStrike pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
