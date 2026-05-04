{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-media-image";
  version = "0.3.132";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_media_image";
    inherit (finalAttrs) version;
    hash = "sha256-fqQ6w7czSCuLUoi8qlw5in32AulCPzGpoMVXLKbCeHc=";
  };

  build-system = [ setuptools ];

  # Package only ships static workflow JSON assets; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_media_image" ];

  meta = {
    description = "Image workflow templates for ComfyUI";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
