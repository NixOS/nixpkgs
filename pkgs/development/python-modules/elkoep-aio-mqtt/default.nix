{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  attrs,
  paho-mqtt,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "elkoep-aio-mqtt";
  version = "0.1.0.beta.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "epdevlab";
    repo = "elkoep-aio-mqtt";
    tag = "0.1.0.beta.4";
    hash = "sha256-pQzM0wLLZk6cEizhDqLbVF4pMeyefgSUU0ay3CiGgAE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    paho-mqtt
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "inelsmqtt" ];

  meta = {
    description = "Python library for iNELS mqtt protocol";
    homepage = "https://github.com/epdevlab/elkoep-aio-mqtt";
    changelog = "https://github.com/epdevlab/elkoep-aio-mqtt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
