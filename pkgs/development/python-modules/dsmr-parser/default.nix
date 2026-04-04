{
  lib,
  buildPythonPackage,
  dlms-cosem,
  fetchFromGitHub,
  pyserial,
  pyserial-asyncio-fast,
  pytestCheckHook,
  pythonAtLeast,
  pytz,
  setuptools,
  tailer,
}:

buildPythonPackage (finalAttrs: {
  pname = "dsmr-parser";
  version = "1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-+dv9V06o1kI6pX/Bq05JmUUvW+KoqauLaWqY6xhs6PE=";
  };

  pythonRelaxDeps = [ "dlms_cosem" ];

  build-system = [ setuptools ];

  dependencies = [
    dlms-cosem
    pyserial
    pyserial-asyncio-fast
    pytz
    tailer
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [ "test_receive_packet" ];

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
