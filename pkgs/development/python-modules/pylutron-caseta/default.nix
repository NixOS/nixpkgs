{
  lib,
  async-timeout,
  buildPythonPackage,
  click,
  cryptography,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  xdg,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "pylutron-caseta";
  version = "0.22.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gurumitts";
    repo = "pylutron-caseta";
    rev = "refs/tags/v${version}";
    hash = "sha256-8NO1IAm16b5jxjVPSQqOSx5hJjAOAXyOknqwkgPT5Zo=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ cryptography ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

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
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "pylutron_caseta" ];

  meta = with lib; {
    description = "Python module o control Lutron Caseta devices";
    homepage = "https://github.com/gurumitts/pylutron-caseta";
    changelog = "https://github.com/gurumitts/pylutron-caseta/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
