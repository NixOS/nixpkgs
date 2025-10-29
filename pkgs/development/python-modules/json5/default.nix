{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json5";
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = "pyjson5";
    tag = "v${version}";
    hash = "sha256-xBErTbC/cw+1bAVPIyN0+0aPmWblNtnsbIKEZ+XIyUQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json5" ];

  meta = {
    description = "Python implementation of the JSON5 data format";
    homepage = "https://github.com/dpranke/pyjson5";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veehaitch ];
    mainProgram = "pyjson5";
  };
}
