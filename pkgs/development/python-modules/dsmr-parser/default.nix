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
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KoSRfkTKdAusDi1twiU4Xs0p4nijDslkDPJMTfUvWsE=";
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
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dsmr_console";
  };
})
