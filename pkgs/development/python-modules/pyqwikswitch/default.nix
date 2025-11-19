{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  uv-build,

  # dependencies
  aiohttp,
  attrs,

  # tests
  aioresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyqwikswitch";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "kellerza";
    repo = "pyqwikswitch";
    tag = "v${version}";
    hash = "sha256-QL0PSlYVh/DKmJZq/4a2XDFmpl/AJQlsCvFLZV6W49k=";
  };

  build-system = [ uv-build ];

  dependencies = [
    aiohttp
    attrs
  ];

  pythonImportsCheck = [ "pyqwikswitch" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/kellerza/pyqwikswitch/releases/tag/${src.tag}";
    description = "QwikSwitch USB Modem API binding for Python";
    homepage = "https://github.com/kellerza/pyqwikswitch";
    license = licenses.mit;
    teams = [ teams.home-assistant ];
  };
}
