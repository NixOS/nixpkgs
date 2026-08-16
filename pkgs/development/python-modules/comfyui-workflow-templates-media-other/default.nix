{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-media-other";
  version = "0.3.229";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_media_other";
    inherit (finalAttrs) version;
    hash = "sha256-bi2wdS8sfOlPaoudRBpfnceLv6dldF8PnqyuzLzmk4U=";
  };

  build-system = [ setuptools ];

  # Package only ships static workflow JSON assets; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_media_other" ];

  meta = {
    description = "Additional workflow templates for ComfyUI";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    inherit (comfyui.meta) maintainers;
  };
})
