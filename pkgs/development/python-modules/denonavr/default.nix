{
  lib,
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
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "denonavr";
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ol-iver";
    repo = "denonavr";
    tag = finalAttrs.version;
    hash = "sha256-5yjrBG7Vufi+O4mHV1yGvunUJY38eWc5ZIoeoZyG5ak=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asyncstdlib
    attrs
    defusedxml
    ftfy
    httpx
    netifaces
  ];

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
    changelog = "https://github.com/ol-iver/denonavr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
