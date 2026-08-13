{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-workflow-templates-core";
  version = "0.3.307";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_workflow_templates_core";
    inherit (finalAttrs) version;
    hash = "sha256-GIvshis5CvvmuY4IvEziIWSWo5DRg4s6RYpd2MnBGuE=";
  };

  build-system = [ setuptools ];

  # Upstream ships a `tests/` suite that resolves sibling packages by
  # walking up to the source monorepo (`packages/{core,meta,media_*}/src`).
  # That layout is not part of the published sdist, so the suite cannot
  # run from a PyPI source checkout.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_workflow_templates_core" ];

  meta = {
    description = "Core loader for ComfyUI workflow templates";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.mit;
    inherit (comfyui.meta) maintainers;
  };
})
