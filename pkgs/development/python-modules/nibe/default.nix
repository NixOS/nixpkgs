{ lib
, aiohttp
, aresponses
, async-modbus
, async-timeout
, buildPythonPackage
, construct
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, tenacity
}:

buildPythonPackage rec {
  pname = "nibe";
  version = "1.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-y1/yZE5Gfj2XPscZ27TNXOM/VGy/iIFkvg2TCNsh4tI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    async-modbus
    async-timeout
    construct
    tenacity
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nibe"
  ];

  meta = with lib; {
    description = "Library for the communication with Nibe heatpumps";
    homepage = "https://github.com/yozik04/nibe";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
