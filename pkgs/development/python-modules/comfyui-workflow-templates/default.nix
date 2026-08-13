{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
  comfyui-workflow-templates-core,
  comfyui-workflow-templates-json,
  comfyui-workflow-templates-media-api,
  comfyui-workflow-templates-media-assets-01,
  comfyui-workflow-templates-media-video,
  comfyui-workflow-templates-media-image,
  comfyui-workflow-templates-media-other,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates";
  version = "0.11.37";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates";
    inherit (finalAttrs) version;
    hash = "sha256-si/bxl5NXk0kSs91EhIwmLhlnWxW+3l4ZvisDI0YSbo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    comfyui-workflow-templates-core
    comfyui-workflow-templates-json
    comfyui-workflow-templates-media-api
    comfyui-workflow-templates-media-assets-01
    comfyui-workflow-templates-media-image
    comfyui-workflow-templates-media-other
    comfyui-workflow-templates-media-video
  ];

  # Package only ships static workflow JSON assets; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates" ];

  meta = {
    description = "Workflow templates for ComfyUI";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    inherit (comfyui.meta) maintainers;
  };
})
