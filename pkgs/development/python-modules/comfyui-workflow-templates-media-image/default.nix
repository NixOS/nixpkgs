{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-media-image";
  version = "0.3.160";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_media_image";
    inherit (finalAttrs) version;
    hash = "sha256-iNz3STAsahL1uAPftGcktMiswx0RF87P9RZy2b2F6xg=";
  };

  build-system = [ setuptools ];

  # Package only ships static workflow JSON assets; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_media_image" ];

  meta = {
    description = "Image workflow templates for ComfyUI";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    inherit (comfyui.meta) maintainers;
  };
})
