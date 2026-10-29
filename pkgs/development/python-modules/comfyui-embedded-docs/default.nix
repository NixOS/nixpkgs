{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-embedded-docs";
  version = "0.5.14";
  pyproject = true;

  # nixpkgs-update: no auto update
  # updated via comfyui
  src = fetchPypi {
    pname = "comfyui_embedded_docs";
    inherit (finalAttrs) version;
    hash = "sha256-5RvDspmbt6iR29KF8JetsRbgsRtc3yN2obrPkOsto4E=";
  };

  build-system = [ setuptools ];

  # Package only ships static Markdown documentation; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_embedded_docs" ];

  meta = {
    description = "Embedded node documentation for ComfyUI";
    homepage = "https://github.com/Comfy-Org/embedded-docs";
    license = lib.licenses.gpl3Only;
    inherit (comfyui.meta) maintainers;
  };
})
