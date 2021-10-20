{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pyserial-asyncio
, pytestCheckHook
, pytz
, tailer
}:

buildPythonPackage rec {
  pname = "dsmr-parser";
  version = "0.30";

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    rev = "v${version}";
    sha256 = "sha256-3RXku0L/XQFarECxY1LSs2TwSOlJAOiS6yEepHCGL5U=";
  };

  propagatedBuildInputs = [
    pyserial
    pyserial-asyncio
    pytz
    tailer
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dsmr_parser" ];

  meta = with lib; {
    description = "Python module to parse Dutch Smart Meter Requirements (DSMR)";
    homepage = "https://github.com/ndokter/dsmr_parser";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
