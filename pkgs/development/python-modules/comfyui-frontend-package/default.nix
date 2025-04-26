{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:
buildPythonPackage rec {
  pname = "comfyui-frontend-package";
  version = "1.17.11";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit version;
    pname = "comfyui_frontend_package";
    hash = "sha256-v2Yfl730hvGEV+kFXva3lAJFDecVplvl+L5XY3PJdNU=";
  };

  pythonImportsCheck = [ "comfyui_frontend_package" ];

  env.COMFYUI_FRONTEND_VERSION = version;

  meta = {
    description = "ComfyUI frontend package";
    homepage = "https://github.com/Comfy-Org/ComfyUI_frontend";
    changelog = "https://github.com/Comfy-Org/ComfyUI_frontend/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ scd31 ];
  };
}
