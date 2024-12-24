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
  pytestCheckHook,
  pytest-httpx,
  pytest-timeout,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "denonavr";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ol-iver";
    repo = "denonavr";
    rev = "refs/tags/${version}";
    hash = "sha256-9nY1z6CX8uha/m3OOUyadrKmpbUsgL16CB2ySElOTck=";
  };

  pythonRelaxDeps = [ "defusedxml" ];

  build-system = [ setuptools ];

  dependencies = [
    asyncstdlib
    attrs
    defusedxml
    ftfy
    httpx
    netifaces
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-httpx
    pytest-timeout
  ];

  pythonImportsCheck = [ "denonavr" ];

  meta = with lib; {
    description = "Automation Library for Denon AVR receivers";
    homepage = "https://github.com/ol-iver/denonavr";
    changelog = "https://github.com/ol-iver/denonavr/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
