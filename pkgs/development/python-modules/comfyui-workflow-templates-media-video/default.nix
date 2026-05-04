{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-media-video";
  version = "0.3.81";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_media_video";
    inherit (finalAttrs) version;
    hash = "sha256-Bdlig7WooxMEs0Tss2D5ExEK5Y/lRsXvIQxmUiQkSHw=";
  };

  build-system = [ setuptools ];

  # Package only ships static workflow JSON assets; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_media_video" ];

  meta = {
    description = "Video workflow templates for ComfyUI";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
