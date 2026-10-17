{
  lib,
  buildPythonPackage,
  click,
  cryptography,
  fetchFromGitHub,
  hatchling,
  orjson,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  xdg,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylutron-caseta";
  version = "0.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gurumitts";
    repo = "pylutron-caseta";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YGdx/WQLM7Dglo4FSEr+QJDKTf7Dyn8V3qSFWNlEu00=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    orjson
  ];

  optional-dependencies = {
    cli = [
      click
      xdg
      zeroconf
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "pylutron_caseta" ];

  meta = {
    description = "Python module to control Lutron Caseta devices";
    homepage = "https://github.com/gurumitts/pylutron-caseta";
    changelog = "https://github.com/gurumitts/pylutron-caseta/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
