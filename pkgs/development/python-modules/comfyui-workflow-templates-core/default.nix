{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-core";
  version = "0.3.216";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_core";
    inherit (finalAttrs) version;
    hash = "sha256-oqmYJmO/rkTwUE0RHd+FqnSHEFYnXsxAL1pbgCmp8/Y=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "comfyui_workflow_templates_core" ];

  meta = {
    description = "Core loader for ComfyUI workflow templates";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
