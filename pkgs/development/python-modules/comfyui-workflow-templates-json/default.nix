{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-json";
  version = "0.1.42";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_json";
    inherit (finalAttrs) version;
    hash = "sha256-Plyqq6rXdSWJc+NHs7rDRdFrYlaSWSWm/+DXMd7/q3I=";
  };

  build-system = [ setuptools ];

  # Package only ships static workflow JSON assets; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_json" ];

  meta = {
    description = "Workflow template JSON definitions for ComfyUI";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    inherit (comfyui.meta) maintainers;
  };
})
