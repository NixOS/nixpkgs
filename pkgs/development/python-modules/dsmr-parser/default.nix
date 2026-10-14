{
  lib,
  buildPythonPackage,
  dlms-cosem,
  fetchFromGitHub,
  pytestCheckHook,
  pythonAtLeast,
  serialx,
  setuptools,
  tailer,
}:

buildPythonPackage (finalAttrs: {
  pname = "dsmr-parser";
  version = "1.11.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MIiJwCRIUSrmp+wfJrfCPW0JY22ATfA66uENgPySgCc=";
  };

  pythonRelaxDeps = [ "dlms_cosem" ];

  build-system = [ setuptools ];

  dependencies = [
    dlms-cosem
    serialx
    tailer
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dsmr_parser" ];

  meta = {
    description = "Python module to parse Dutch Smart Meter Requirements (DSMR)";
    homepage = "https://github.com/ndokter/dsmr_parser";
    changelog = "https://github.com/ndokter/dsmr_parser/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dsmr_console";
  };
})
