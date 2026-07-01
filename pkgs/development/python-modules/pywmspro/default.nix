{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywmspro";
  version = "0.3.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mback2k";
    repo = "pywmspro";
    tag = finalAttrs.version;
    hash = "sha256-01jXkSZfmBIzrz0B/4/KLcAU4jUQGDfle4sE4saraJo=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ aiohttp ];

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
