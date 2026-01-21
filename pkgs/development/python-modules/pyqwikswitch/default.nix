{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  aiohttp,
  uv-build,
  aioresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyqwikswitch";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kellerza";
    repo = "pyqwikswitch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yx3rCPVuhsemAtFuEhPvFPHOFm2UWrXmWF3d/ZtPGo8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv-build>=0.8.20,<0.9" uv-build
  '';

  build-system = [ uv-build ];

  dependencies = [
    aiohttp
    attrs
  ];

  pythonImportsCheck = [
    "pyqwikswitch"
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/kellerza/pyqwikswitch/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "QwikSwitch USB Modem API binding for Python";
    homepage = "https://github.com/kellerza/pyqwikswitch";
    license = lib.licenses.mit;
    teams = [ lib.teams.home-assistant ];
  };
})
