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

buildPythonPackage rec {
  pname = "pylutron-caseta";
  version = "0.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gurumitts";
    repo = "pylutron-caseta";
    tag = "v${version}";
    hash = "sha256-0HH+tEZoMTmvD3z67nJWauQfxoQ/IK1Bxlu1XbWGqI4=";
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
    changelog = "https://github.com/gurumitts/pylutron-caseta/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
