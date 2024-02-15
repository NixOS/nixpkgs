{ lib
, aiohttp
, aresponses
, async-modbus
, async-timeout
, asyncclick
, buildPythonPackage
, construct
, exceptiongroup
, fetchFromGitHub
, pandas
, pytest-asyncio
, pytestCheckHook
, python-slugify
, pythonOlder
, setuptools
, tenacity
}:

buildPythonPackage rec {
  pname = "nibe";
  version = "2.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = "nibe";
    rev = "refs/tags/${version}";
    hash = "sha256-baw2uJn2M0tcP897+h88aMkVul6l170Vyz6qwFHZ8+s=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    async-modbus
    async-timeout
    construct
    exceptiongroup
    tenacity
  ];

  passthru.optional-dependencies = {
    convert = [
      pandas
      python-slugify
    ];
    cli = [
      asyncclick
    ];
  };

  nativeCheckInputs = [
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
    changelog = "https://github.com/yozik04/nibe/releases/tag/${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
