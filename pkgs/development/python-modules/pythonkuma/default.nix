{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-regex-commit,
  hatchling,
  mashumaro,
  prometheus-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "pythonkuma";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "pythonkuma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jQapfwdDuHb5Ha25cUQycfRb/A07pRtm92Iy8bbYfqI=";
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

  pythonImportsCheck = [ "pythonkuma" ];

  meta = {
    description = "Simple Python wrapper for Uptime Kuma";
    homepage = "https://github.com/tr4nt0r/pythonkuma";
    changelog = "https://github.com/tr4nt0r/pythonkuma/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
