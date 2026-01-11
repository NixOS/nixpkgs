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

buildPythonPackage rec {
  pname = "dsmr-parser";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    tag = "v${version}";
    hash = "sha256-jBrcliN63isFKMqgaFIAPP/ALDdtL/O9mCN8Va+g+NE=";
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
    changelog = "https://github.com/ndokter/dsmr_parser/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dsmr_console";
  };
}
