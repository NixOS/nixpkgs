{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-regex-commit,
  hatchling,
  mashumaro,
  prometheus-client,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pythonkuma";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "pythonkuma";
    tag = "v${version}";
    hash = "sha256-1coD4bDLMWQLvN3zt/++hmut0DLdg7aAKz5HtDhomso=";
  };

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  dependencies = [
    aiohttp
    mashumaro
    prometheus-client
  ];

  # Tests are minimal and don't test functionality
  doCheck = false;

  pythonImportsCheck = [
    "pythonkuma"
  ];

  meta = {
    description = "Simple Python wrapper for Uptime Kuma";
    homepage = "https://github.com/tr4nt0r/pythonkuma";
    changelog = "https://github.com/tr4nt0r/pythonkuma/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
