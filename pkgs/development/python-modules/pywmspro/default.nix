{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  aiofiles,
  aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywmspro";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mback2k";
    repo = "pywmspro";
    tag = finalAttrs.version;
    hash = "sha256-gpAAGrM/dLSD7rCbYM9O3hVCvDb0QA0joZG7h+jTfCg=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiofiles
    aiohttp
  ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "wmspro" ];

  meta = {
    changelog = "https://github.com/mback2k/pywmspro/releases/tag/${finalAttrs.src.tag}";
    description = "Python library for WMS WebControl pro API";
    homepage = "https://github.com/mback2k/pywmspro";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
