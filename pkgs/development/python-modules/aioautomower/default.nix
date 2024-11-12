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
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "aioautomower";
  version = "2024.10.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Thomas55555";
    repo = "aioautomower";
    rev = "refs/tags/${version}";
    hash = "sha256-kLsHJBmNxh+PmJQ9Y9Ve/CACovzsRZyzVjor/VKUmYk=";
  };

  postPatch = ''
    # Upstream doesn't set a version
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    ical
    mashumaro
    pyjwt
    tzlocal
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytest-cov-stub
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
