{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysigma-pipeline-sysmon";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-sysmon";
    rev = "refs/tags/v${version}";
    hash = "sha256-aRgnjqSrzmzDCICRiozTGkFmWuCzBpo8k9/YLcylg3w=";
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
    "sigma.pipelines.sysmon"
  ];

  meta = with lib; {
    description = "Library to support Sysmon pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-sysmon";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
