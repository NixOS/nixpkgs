{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-media-assets-01";
  version = "0.1.28";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_media_assets_01";
    inherit (finalAttrs) version;
    hash = "sha256-GVqoISv6e2yhOmX9JihGEkRAZFW/kRbobdZpWszkmWA=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_media_assets_01" ];

  meta = {
    description = "Media assets bundle 01 for ComfyUI workflow templates";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    inherit (comfyui.meta) maintainers;
  };
})
