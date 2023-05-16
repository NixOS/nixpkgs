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
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-nPhXJgky9/CgqBnyqbF2+BASHRSpwKd0ePIRFMq29Vc=";
=======
    hash = "sha256-M6ztqENIeD5foagKUXtJiGfFZPHsczlB0/AH4FMIsLY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
