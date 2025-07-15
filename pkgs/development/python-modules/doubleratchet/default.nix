{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  pydantic,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "doubleratchet";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-doubleratchet";
    tag = "v${version}";
    hash = "sha256-TgkRityDMSzyF6ihM63lAGCSrCHCHrsbCyGYUaObvDU=";
  };

  strictDeps = true;

  build-system = [
    setuptools
  ];

  dependencies = [
    cryptography
    pydantic
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "doubleratchet" ];

  meta = {
    description = "Python implementation of the Double Ratchet algorithm";
    homepage = "https://github.com/Syndace/python-doubleratchet";
    changelog = "https://github.com/Syndace/python-doubleratchet/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    teams = with lib.teams; [ ngi ];
    maintainers = with lib.maintainers; [ axler1 ];
  };
}
