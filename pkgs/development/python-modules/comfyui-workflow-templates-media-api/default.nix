{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-media-api";
  version = "0.3.70";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_media_api";
    inherit (finalAttrs) version;
    hash = "sha256-yFcReKpkqdb0lqfh3krs+6V6IQMfWeoD6FbSQsE88tQ=";
  };

  build-system = [ setuptools ];

  # Package only ships static workflow JSON assets; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_media_api" ];

  meta = {
    description = "API workflow templates for ComfyUI";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
