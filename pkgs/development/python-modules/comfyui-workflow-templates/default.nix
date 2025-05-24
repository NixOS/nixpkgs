{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:
buildPythonPackage rec {
  pname = "comfyui-workflow-templates";
  version = "0.1.3";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit version;
    pname = "comfyui_workflow_templates";
    hash = "sha256-Ivnf+xOOGzMJpu68RFH37vFPEsT9g/KxWUlMiE+Hglk=";
  };

  pythonImportsCheck = [ "comfyui_workflow_templates" ];

  meta = {
    description = "ComfyUI workflow templates";
    homepage = "https://github.com/Comfy-Org/workflow_templates";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ scd31 ];
  };
}
