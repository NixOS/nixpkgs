{ lib
, buildPythonPackage
, dlms-cosem
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, pytz
, tailer
}:

buildPythonPackage rec {
  pname = "dsmr-parser";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-4L7hLDd/hYYdhnkcPRK48FnHutbyDXpnhQoVXUQLoDo=";
  };

  propagatedBuildInputs = [
    dlms-cosem
    pyserial
    pyserial-asyncio
    pytz
    tailer
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    "test_receive_packet"
  ];

  pythonImportsCheck = [
    "dsmr_parser"
  ];

  meta = with lib; {
    description = "Python module to parse Dutch Smart Meter Requirements (DSMR)";
    mainProgram = "dsmr_console";
    homepage = "https://github.com/ndokter/dsmr_parser";
    changelog = "https://github.com/ndokter/dsmr_parser/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
