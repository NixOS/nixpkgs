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
  setuptools,
  syrupy,
  tenacity,
  textual,
}:

buildPythonPackage (finalAttrs: {
  pname = "nibe";
  version = "2.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yozik04";
    repo = "nibe";
    tag = finalAttrs.version;
    hash = "sha256-wsGkpMSiC8sibmHPkg++YUEOnkObhEOeGkJgyaHyZ9M=";
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
    cli = [
      asyncclick
      textual
    ];
  };

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "nibe" ];

  meta = {
    description = "Library for the communication with Nibe heatpumps";
    homepage = "https://github.com/yozik04/nibe";
    changelog = "https://github.com/yozik04/nibe/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
