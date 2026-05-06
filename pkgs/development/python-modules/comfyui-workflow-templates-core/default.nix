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
    maintainers = with lib.maintainers; [ caniko ];
  };
})
