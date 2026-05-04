{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-media-other";
  version = "0.3.182";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_media_other";
    inherit (finalAttrs) version;
    hash = "sha256-TZXVRhB+ROI7r9ClciCw/VDtkkkBMkQ+Kpkuc1rAs6M=";
  };

  build-system = [ setuptools ];

  # Package only ships static workflow JSON assets; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_media_other" ];

  meta = {
    description = "Additional workflow templates for ComfyUI";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
