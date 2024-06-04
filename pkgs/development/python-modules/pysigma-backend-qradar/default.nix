{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pysigma-pipeline-sysmon,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  requests,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-qradar";
  version = "0.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nNipsx-Sec";
    repo = "pySigma-backend-qradar";
    rev = "refs/tags/v${version}";
    hash = "sha256-VymaxX+iqrRlf+WEt4xqEvNt5kg8xI5O/MoYahayu0o=";
  };

  pythonRelaxDeps = [ "pysigma" ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [ pysigma ];

  nativeCheckInputs = [
    pysigma-pipeline-sysmon
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sigma.backends.qradar" ];

  meta = with lib; {
    description = "Library to support Qradar for pySigma";
    homepage = "https://github.com/nNipsx-Sec/pySigma-backend-qradar";
    changelog = "https://github.com/nNipsx-Sec/pySigma-backend-qradar/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
