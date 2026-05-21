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
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-splunk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OIW/ylN4QlguKnY2/yLICEu3Ix41lfXN5qil5dD+eTM=";
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
