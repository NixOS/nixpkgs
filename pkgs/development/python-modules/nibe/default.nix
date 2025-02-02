{
  lib,
  aiohttp,
  aresponses,
  async-modbus,
  async-timeout,
  asyncclick,
  buildPythonPackage,
  construct,
  exceptiongroup,
  fetchFromGitHub,
  pandas,
  pytest-asyncio,
  pytestCheckHook,
  python-slugify,
  pythonOlder,
  setuptools,
  tenacity,
}:

buildPythonPackage rec {
  pname = "nibe";
  version = "2.10.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = "nibe";
    rev = "refs/tags/${version}";
    hash = "sha256-g43lXQzsQ1Serq6oIMcnAYwUppdEVcBkYGEoy3NIwqo=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    cli = [ asyncclick ];
  };

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nibe" ];

  meta = with lib; {
    description = "Library for the communication with Nibe heatpumps";
    homepage = "https://github.com/yozik04/nibe";
    changelog = "https://github.com/yozik04/nibe/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
