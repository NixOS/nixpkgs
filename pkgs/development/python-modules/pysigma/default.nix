{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  packaging,
  poetry-core,
  pyparsing,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "pysigma";
  version = "0.11.14";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma";
    rev = "refs/tags/v${version}";
    hash = "sha256-jxVTXw3WZcOL5IDUHs+DRGoXDRFn99UWOz5j5mCEf8A=";
  };

  pythonRelaxDeps = [
    "jinja2"
    "packaging"
  ];

  build-system = [ poetry-core ];


  dependencies = [
    jinja2
    packaging
    pyparsing
    pyyaml
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Tests require network connection
    "test_sigma_plugin_directory_default"
    "test_sigma_plugin_installation"
  ];

  pythonImportsCheck = [ "sigma" ];

  meta = with lib; {
    description = "Library to parse and convert Sigma rules into queries";
    homepage = "https://github.com/SigmaHQ/pySigma";
    changelog = "https://github.com/SigmaHQ/pySigma/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
