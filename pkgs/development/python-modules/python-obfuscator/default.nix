{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  regex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-obfuscator";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "davidteather";
    repo = "python-obfuscator";
    tag = "V${version}";
    hash = "sha256-LUD+9vNd1sdigbKG2tm5hE3zLtmor/2LqsIarUWS2Ek=";
  };

  build-system = [ setuptools ];

  dependencies = [ regex ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "python_obfuscator" ];

  meta = {
    description = "Module to obfuscate code";
    homepage = "https://github.com/davidteather/python-obfuscator";
    changelog = "https://github.com/davidteather/python-obfuscator/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
