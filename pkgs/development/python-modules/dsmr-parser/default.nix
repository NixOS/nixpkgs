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
  version = "0.29";

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    rev = "v${version}";
    sha256 = "11d6cwmabzc8p6jkqwj72nrj7p6cxbvr0x3jdrxyx6zki8chyw4p";
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
