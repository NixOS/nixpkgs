{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-media-assets-01";
  version = "0.1.44";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_media_assets_01";
    inherit (finalAttrs) version;
    hash = "sha256-DduG6ec1PF3INHQb5wDzb/pf7/fMHjLdGyN3Uh5dINI=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_media_assets_01" ];

  meta = {
    description = "Media assets bundle 01 for ComfyUI workflow templates";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    inherit (comfyui.meta) maintainers;
  };
})
