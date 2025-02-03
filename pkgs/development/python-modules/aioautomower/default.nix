{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  ical,
  mashumaro,
  poetry-core,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  syrupy,
}:

buildPythonPackage rec {
  pname = "aioautomower";
  version = "2024.9.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Thomas55555";
    repo = "aioautomower";
    rev = "refs/tags/${version}";
    hash = "sha256-MdsK+QP8YdMceTiNwhuf84KARIHCyn7/g6WKrDB6yCc=";
  };

  postPatch = ''
    # Upstream doesn't set a version
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"' \
      --replace-fail "--cov" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    ical
    mashumaro
    pyjwt
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "aioautomower" ];

  pytestFlagsArray = [ "--snapshot-update" ];

  disabledTests = [
    # File is missing
    "test_standard_mower"
    # Call no found
    "test_post_commands"
  ];

  meta = with lib; {
    description = "Module to communicate with the Automower Connect API";
    homepage = "https://github.com/Thomas55555/aioautomower";
    changelog = "https://github.com/Thomas55555/aioautomower/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
