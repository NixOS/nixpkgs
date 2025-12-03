{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pysigma-pipeline-sysmon,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-splunk";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-splunk";
    tag = "v${version}";
    hash = "sha256-SiEESeF0YqPYDAK3OUEkqSHmn4uM5LQrCLOHvOy26Io=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ pysigma ];

  nativeCheckInputs = [
    pysigma-pipeline-sysmon
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sigma.backends.splunk" ];

  meta = {
    description = "Library to support Splunk for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-splunk";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-splunk/releases/tag/${src.tag}";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fab ];
  };
}
