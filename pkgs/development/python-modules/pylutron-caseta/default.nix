{
  lib,
  async-timeout,
  buildPythonPackage,
  click,
  cryptography,
  fetchFromGitHub,
  hatchling,
  orjson,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  xdg,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "pylutron-caseta";
  version = "0.26.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gurumitts";
    repo = "pylutron-caseta";
    tag = "v${version}";
    hash = "sha256-aH6EX0cpMteCmZCoUd9pwB0sQ7GIhxtesvURIx32adA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    orjson
  ]
  ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "pylutron_caseta" ];

  meta = with lib; {
    description = "Python module to control Lutron Caseta devices";
    homepage = "https://github.com/gurumitts/pylutron-caseta";
    changelog = "https://github.com/gurumitts/pylutron-caseta/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
