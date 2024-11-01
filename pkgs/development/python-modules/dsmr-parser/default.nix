{
  lib,
  buildPythonPackage,
  dlms-cosem,
  fetchFromGitHub,
  pyserial,
  pyserial-asyncio-fast,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  pytz,
  setuptools,
  tailer,
}:

buildPythonPackage rec {
  pname = "dsmr-parser";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-NfleByW9MF7FS4n/cMv297382LucP6Z629CuA6chm20=";
  };

  pythonRelaxDeps = [ "dlms-cosem" ];

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

  meta = with lib; {
    description = "Python module to parse Dutch Smart Meter Requirements (DSMR)";
    homepage = "https://github.com/ndokter/dsmr_parser";
    changelog = "https://github.com/ndokter/dsmr_parser/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "dsmr_console";
  };
}
