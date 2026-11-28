{
  lib,
  buildPythonPackage,
  bleak,
  fetchFromGitHub,
  modbus-tk,
  uv-build,
  pytest-asyncio,
  pytestCheckHook,
  tenacity,
  tmodbus,
}:

buildPythonPackage (finalAttrs: {
  pname = "riden";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "acc15";
    repo = "riden";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZGLvw0W4xNmdl/HMIqqqcHUm1ZUWny6W7TR71ffi2Fk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.13.7,<0.14.0" "uv_build"
  '';

  pythonRelaxDeps = [ "bleak" ];

  build-system = [ uv-build ];

  dependencies = [
    bleak
    tmodbus
    tenacity
  ]
  ++ tmodbus.optional-dependencies.async-serial;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "riden" ];

  meta = {
    description = "Module for Riden RD power supplies";
    homepage = "https://github.com/acc15/riden";
    changelog = "https://github.com/acc15/riden/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
