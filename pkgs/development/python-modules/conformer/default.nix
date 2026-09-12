{
  lib,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  setuptools,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "conformer";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "conformer";
    tag = finalAttrs.version;
    hash = "sha256-ibHlDFgWm9iW2VOYMrXssPPW2jNqnjqKo3B6wrc7cmM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    einops
    torch
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "conformer" ];

  meta = {
    description = "Convolutional module from the Conformer paper";
    homepage = "https://github.com/lucidrains/conformer";
    changelog = "https://github.com/lucidrains/conformer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
