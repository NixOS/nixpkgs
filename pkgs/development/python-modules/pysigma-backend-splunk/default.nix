{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pysigma-pipeline-sysmon,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysigma-backend-splunk";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-splunk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4nxFAlCU0GbyCnLRPWffP1kdXecmxVw71SLvOh0JuEw=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [
    pysigma-pipeline-sysmon
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sigma.backends.splunk" ];

  meta = {
    description = "Library to support Splunk for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-splunk";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-splunk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
