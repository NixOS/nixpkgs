{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  typing-extensions,
  importlib-metadata,
  hatch-fancy-pypi-readme,
}:
buildPythonPackage (finalAttrs: {
  pname = "lunr";
  version = "0.8.0";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "yeraydiazdiaz";
    repo = "lunr.py";
    tag = "${finalAttrs.version}";
    hash = "sha256-47gLvelEiPuOC/OvQBy+Es1zCt+NfdC0AFTISviHn6k=";
  };
  dependencies = [ hatch-fancy-pypi-readme ];
  build-system = [
    hatchling
  ];
  meta = {
    description = "Python implementation of Lunr.js";
    homepage = "https://github.com/yeraydiazdiaz/lunr.py";
    changelog = "https://github.com/yeraydiazdiaz/lunr.py/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
