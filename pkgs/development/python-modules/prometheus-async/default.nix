{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  prometheus-client,
  pytest-asyncio,
  pytestCheckHook,
  twisted,
  typing-extensions,
  wrapt,
}:

buildPythonPackage rec {
  pname = "prometheus-async";
  version = "25.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "prometheus-async";
    rev = version;
    hash = "sha256-e/BVxATpafxddq26Rt7XTiK4ajY+saUApXbmTG0/I6I=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    prometheus-client
    typing-extensions
    wrapt
  ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    consul = [ aiohttp ];
    twisted = [ twisted ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "prometheus_async" ];

  meta = with lib; {
    description = "Async helpers for prometheus_client";
    homepage = "https://github.com/hynek/prometheus-async";
    changelog = "https://github.com/hynek/prometheus-async/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
