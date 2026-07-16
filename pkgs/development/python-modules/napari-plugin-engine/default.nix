{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "napari-plugin-engine";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari-plugin-engine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GdOip1ekw4MUzGugiaYQQvBKkZaKVoWI/rASelrNmAU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # Circular dependency: napari
  doCheck = false;

  pythonImportsCheck = [ "napari_plugin_engine" ];

  meta = {
    description = "First generation napari plugin engine";
    homepage = "https://github.com/napari/napari-plugin-engine";
    changelog = "https://github.com/napari/napari-plugin-engine/releases/tag/{finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
})
