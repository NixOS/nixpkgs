{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hidapi,
  loguru,
  pyserial,
  pytest-asyncio,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "busylight-core";
  version = "0.15.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JnyJny";
    repo = "busylight-core";
    tag = "v${version}";
    hash = "sha256-r7mAKD/uodY5RRklYL6u2HTdcU+rt6taTpBkTB/Sv9Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.7.19,<0.8" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    hidapi
    loguru
    pyserial
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "busylight_core" ];

  meta = {
    description = "Library for interacting programmatically with USB-connected LED lights";
    homepage = "https://github.com/JnyJny/busylight-core";
    changelog = "https://github.com/JnyJny/busylight-core/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
