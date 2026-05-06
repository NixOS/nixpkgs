{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui-workflow-templates-core,
  comfyui-workflow-templates-media-api,
  comfyui-workflow-templates-media-video,
  comfyui-workflow-templates-media-image,
  comfyui-workflow-templates-media-other,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates";
  version = "0.9.63";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates";
    inherit (finalAttrs) version;
    hash = "sha256-aadoH3Ccpbyi/K/CGaQVWmjHWxYNiGWFjXF8mH+S//c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    comfyui-workflow-templates-core
    comfyui-workflow-templates-media-api
    comfyui-workflow-templates-media-video
    comfyui-workflow-templates-media-image
    comfyui-workflow-templates-media-other
  ];

  # Package only ships static workflow JSON assets; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates" ];

  meta = {
    description = "Workflow templates for ComfyUI";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
