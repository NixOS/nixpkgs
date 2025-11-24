{
  lib,
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
  version = "2.19.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = "nibe";
    tag = version;
    hash = "sha256-1Awf/7AUSsLo9O2GrVvdlHm5Fcj2CQ7TdKY152bogfQ=";
  };

  pythonRelaxDeps = [ "async-modbus" ];

  build-system = [ setuptools ];

  dependencies = [
    async-modbus
    async-timeout
    construct
    exceptiongroup
    tenacity
  ];

  optional-dependencies = {
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
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "nibe" ];

  meta = with lib; {
    description = "Library for the communication with Nibe heatpumps";
    homepage = "https://github.com/yozik04/nibe";
    changelog = "https://github.com/yozik04/nibe/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
