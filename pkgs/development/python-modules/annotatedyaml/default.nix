{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  poetry-core,
  propcache,
  pytest-asyncio,
  pytest-codspeed,
  pytest-cov-stub,
  pytestCheckHook,
  pyyaml,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "annotatedyaml";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "annotatedyaml";
    tag = "v${version}";
    hash = "sha256-bVXhKm69A5FIXYY2yq7jXPIK7lSCQD20a3oX1GdqOLY=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [
    propcache
    pyyaml
    voluptuous
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-codspeed
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "annotatedyaml" ];

  meta = {
    description = "Annotated YAML that supports secrets for Python";
    homepage = "https://github.com/home-assistant-libs/annotatedyaml";
    changelog = "https://github.com/home-assistant-libs/annotatedyaml/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
