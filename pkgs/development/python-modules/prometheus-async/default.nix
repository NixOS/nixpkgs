{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  flit-core,

  prometheus-client,
  typing-extensions,
  wrapt,
  aiohttp,
  twisted,

  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "prometheus-async";
  version = "22.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "prometheus-async";
    rev = version;
    hash = "sha256-2C4qr0gLYHndd49UfjtuF/v05Hl2PuyegPUhCAmd5/E=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    prometheus-client
    typing-extensions
    wrapt
  ];

  optional-dependencies = {
    aiohttp = [
      aiohttp
    ];
    consul = [
      aiohttp
    ];
    twisted = [
      twisted
    ];
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
