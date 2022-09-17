{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysigma-pipeline-windows";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-windows";
    rev = "refs/tags/v${version}";
    hash = "sha256-/DUhgvcGhk28HRDCi96K1NH6MHNB1WogfuMVCgNbot4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma.pipelines.windows"
  ];

  meta = with lib; {
    description = "Library to support Windows service pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-windows";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
