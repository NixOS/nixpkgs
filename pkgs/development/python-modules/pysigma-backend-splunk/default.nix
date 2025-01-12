{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pysigma-pipeline-sysmon,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-splunk";
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-splunk";
    tag = "v${version}";
    hash = "sha256-6L+o+XM+im8qJFyd3h+b1ZxY1QSEdoXDop5en33fECI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ pysigma ];

  nativeCheckInputs = [
    pysigma-pipeline-sysmon
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sigma.backends.splunk" ];

  meta = with lib; {
    description = "Library to support Splunk for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-splunk";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-splunk/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
