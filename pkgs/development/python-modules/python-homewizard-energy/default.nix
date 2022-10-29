{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-homewizard-energy";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "DCSBL";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-aaTxUx1eMM4Me4D0EkV5iDzs+yPt83/7PyPXTCTIgq8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "homewizard_energy"
  ];

  meta = with lib; {
    description = "Library to communicate with HomeWizard Energy devices";
    homepage = "https://github.com/DCSBL/python-homewizard-energy";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
