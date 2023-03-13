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
  version = "0.1.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-crowdstrike";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZSTnQmdLcMa1XwbQxGpE734yN92zDy72SX9feTL9wjI=";
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
