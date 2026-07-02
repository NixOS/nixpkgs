{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  httpx,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "netdata";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-netdata";
    tag = finalAttrs.version;
    hash = "sha256-rffqpvqVvCi7CKjDchgRzUWDNxsA7C37UHvbELewR0E=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    yarl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "netdata" ];

  meta = {
    description = "Python API for interacting with Netdata";
    homepage = "https://github.com/home-assistant-ecosystem/python-netdata";
    changelog = "https://github.com/home-assistant-ecosystem/python-netdata/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
