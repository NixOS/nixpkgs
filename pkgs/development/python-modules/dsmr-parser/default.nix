{ lib
, buildPythonPackage
, dlms-cosem
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, pytestCheckHook
, pythonOlder
, pytz
, tailer
}:

buildPythonPackage rec {
  pname = "dsmr-parser";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-nPhXJgky9/CgqBnyqbF2+BASHRSpwKd0ePIRFMq29Vc=";
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

  pythonImportsCheck = [
    "dsmr_parser"
  ];

  meta = with lib; {
    description = "Python module to parse Dutch Smart Meter Requirements (DSMR)";
    homepage = "https://github.com/ndokter/dsmr_parser";
    changelog = "https://github.com/ndokter/dsmr_parser/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
