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
  pytest-cov-stub,
  pytest-freezegun,
  pytest-timeout,
  pytestCheckHook,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "pylitterbot";
  version = "2025.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = "pylitterbot";
    tag = version;
    hash = "sha256-EK2QiQMHhA69p7xnyeYE+kru0k7eL9EilkAUAN6LukU=";
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
    pytest-cov-stub
    pytest-freezegun
    pytest-timeout
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
