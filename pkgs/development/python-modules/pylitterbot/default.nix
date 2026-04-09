{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  deepdiff,
  fetchFromGitHub,
  hatchling,
  pycognito,
  pyjwt,
  pytest-aiohttp,
  pytest-freezegun,
  pytestCheckHook,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "pylitterbot";
  version = "2025.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = "pylitterbot";
    tag = version;
    hash = "sha256-o5A4AWil6FeHjUBgbHaA010kszhuncHHzf8+CH4QL0c=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    deepdiff
    pycognito
    pyjwt
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylitterbot" ];

  meta = {
    description = "Modulefor controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
    changelog = "https://github.com/natekspencer/pylitterbot/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
