{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  mkdocs,
}:

buildPythonPackage (finalAttrs: {
  pname = "mkdocs-custom-tags-attributes";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mara-Li";
    repo = "mkdocs-custom-tags-attributes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oP2yfq16gc+0aA7GOcXKZ2x4n5AakWMHy3RO3o0MaqI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mkdocs
  ];

  pythonImportsCheck = [
    "custom_attributes"
  ];

  doCheck = false;

  meta = {
    description = "A mkdocs plugin to create custom attributes using hashtags";
    homepage = "https://github.com/Mara-Li/mkdocs-custom-tags-attributes";
    changelog = "https://github.com/Mara-Li/mkdocs-custom-tags-attributes/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mkdocs-custom-tags-attributes";
  };
})
