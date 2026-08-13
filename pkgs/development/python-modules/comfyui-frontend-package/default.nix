{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-frontend-package";
  version = "1.48.7";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_frontend_package";
    inherit (finalAttrs) version;
    hash = "sha256-7E7N5pXX4bbdIFJ88Nc9Iub1P1y+Czv7nZjamaa8NDg=";
  };

  build-system = [ setuptools ];

  env = {
    COMFYUI_FRONTEND_VERSION = finalAttrs.version;
  };

  # Package only ships the prebuilt frontend bundle; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_frontend_package" ];

  meta = {
    description = "Frontend assets for ComfyUI";
    homepage = "https://github.com/Comfy-Org/ComfyUI_frontend";
    license = lib.licenses.gpl3Only;
    inherit (comfyui.meta) maintainers;
    # The frontend is fetched as a prebuilt PyPI sdist. Building from source
    # is tracked as a follow-up (see nixpkgs#441841).
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
