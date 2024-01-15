{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysigma-pipeline-crowdstrike";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-crowdstrike";
    rev = "refs/tags/v${version}";
    hash = "sha256-kopZ4bbWX0HNrqos9XO/DfbdExlgZcDLEsUpOBumvBA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma.pipelines.crowdstrike"
  ];

  meta = with lib; {
    description = "Library to support CrowdStrike pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-crowdstrike";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
