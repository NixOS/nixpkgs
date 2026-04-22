{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  bleak,
  bleak-retry-connector,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hueble";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flip-dots";
    repo = "HueBLE";
    tag = "v${version}";
    hash = "sha256-JbihHDG44PeS6rxUOXSRF9NlH/smUGz3/JrCmXqTT5s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  pythonImportsCheck = [ "HueBLE" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/flip-dots/HueBLE/blob/${src.tag}/CHANGELOG.rst";
    description = "Python module for controlling Bluetooth Philips Hue lights";
    homepage = "https://github.com/flip-dots/HueBLE";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
