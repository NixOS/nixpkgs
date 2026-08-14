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
  version = "0.11.41";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates";
    inherit (finalAttrs) version;
    hash = "sha256-vzTTCvGVM9ckvF9mSY5umpZ784CfScEcLiNrzJAq/N0=";
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
