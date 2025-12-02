{
  lib,
  async-timeout,
  asyncstdlib,
  attrs,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  ftfy,
  httpx,
  netifaces,
  pytest-asyncio,
  pytest-httpx,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "denonavr";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ol-iver";
    repo = "denonavr";
    tag = version;
    hash = "sha256-/GhlSZhl4VAl0em3QLolSRS0wZQeOhhF+B/91ohqVPw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asyncstdlib
    attrs
    defusedxml
    ftfy
    httpx
    netifaces
  ]
  ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-httpx
    pytest-timeout
  ];

  pythonImportsCheck = [ "denonavr" ];

  meta = {
    description = "Automation Library for Denon AVR receivers";
    homepage = "https://github.com/ol-iver/denonavr";
    changelog = "https://github.com/ol-iver/denonavr/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
