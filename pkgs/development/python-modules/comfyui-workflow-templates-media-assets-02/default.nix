{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-media-assets-02";
  version = "0.1.11";
  pyproject = true;

  # nixpkgs-update: no auto update
  # updated via comfyui
  src = fetchPypi {
    pname = "comfyui_workflow_templates_media_assets_02";
    inherit (finalAttrs) version;
    hash = "sha256-DhJhA/C0/sPOjLhM/m2Z0hn6dUChjGQrOzJTPlc1XDg=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_media_assets_02" ];

  meta = {
    description = "Media assets bundle 02 for ComfyUI workflow templates";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    inherit (comfyui.meta) maintainers;
  };
})
