{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aionanoleaf2";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "loebi-ch";
    repo = "aionanoleaf2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+t7CqNNFc6otuAeEwBaW2Oq8HLDibsVuUvxZV22XPOU=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "aionanoleaf2" ];

  meta = {
    description = "Async Python package for the Nanoleaf API";
    homepage = "https://github.com/loebi-ch/aionanoleaf2";
    changelog = "https://github.com/loebi-ch/aionanoleaf2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
