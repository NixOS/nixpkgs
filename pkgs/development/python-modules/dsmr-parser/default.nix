{ lib
, buildPythonPackage
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
  version = "0.33";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ndokter";
    repo = "dsmr_parser";
    rev = "v${version}";
    sha256 = "sha256-Phx8Yqx6beTzkQv0fU8Pfs2btPgKVARdO+nMcne1S+w=";
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

  pythonImportsCheck = [
    "dsmr_parser"
  ];

  meta = with lib; {
    description = "Python module to parse Dutch Smart Meter Requirements (DSMR)";
    homepage = "https://github.com/ndokter/dsmr_parser";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
