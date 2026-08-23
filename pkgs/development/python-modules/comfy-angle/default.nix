{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  libGL,
  setuptools,
  stdenv,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfy-angle";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "comfy-angle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FnS2aQmPb5a3dO9m5McpO5Kfyy1aOaboc+oAtYqauQo=";
  };

  postPatch = ''
    mkdir -p comfy_angle/libs
    ln -s ${lib.getLib libGL}/lib/{libEGL,libGLESv2}${stdenv.hostPlatform.extensions.sharedLibrary} comfy_angle/libs/
  '';

  build-system = [
    setuptools
  ];

  # Repository has no tests
  doCheck = false;

  pythonImportsCheck = [ "comfy_angle" ];

  meta = {
    description = "Redistributable ANGLE libraries";
    homepage = "https://github.com/Comfy-Org/comfy-aimdo";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    inherit (comfyui.meta) maintainers;
  };
})
