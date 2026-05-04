{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-frontend-package";
  version = "1.42.15";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_frontend_package";
    inherit (finalAttrs) version;
    hash = "sha256-V1j+wiJSMyePkySd0PaNs99XLx3B4zT/tp7uV3AxuBQ=";
  };

  build-system = [ setuptools ];

  # Package only ships the prebuilt frontend bundle; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_frontend_package" ];

  meta = {
    description = "Frontend assets for ComfyUI";
    homepage = "https://github.com/Comfy-Org/ComfyUI_frontend";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
