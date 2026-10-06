{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-media-assets-02";
  version = "0.1.3";
  pyproject = true;

  # nixpkgs-update: no auto update
  # updated via comfyui
  src = fetchPypi {
    pname = "comfyui_workflow_templates_media_assets_02";
    inherit (finalAttrs) version;
    hash = "sha256-VqEUtsbYFoySosWw7RySa09aFVkAr3+Bzcf9Bf1flCQ=";
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
