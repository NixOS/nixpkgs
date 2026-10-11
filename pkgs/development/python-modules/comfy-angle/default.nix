{
  lib,
  angle,
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

  # Upstream wheels bundle ANGLE on macOS; on Linux the system libGL provides EGL
  postPatch =
    let
      egl = if stdenv.hostPlatform.isDarwin then angle else lib.getLib libGL;
    in
    ''
      mkdir -p comfy_angle/libs
      ln -s ${egl}/lib/{libEGL,libGLESv2}${stdenv.hostPlatform.extensions.sharedLibrary} comfy_angle/libs/
    '';

  build-system = [
    setuptools
  ];

  # Repository has no tests
  doCheck = false;

  pythonImportsCheck = [ "comfy_angle" ];

  meta = {
    description = "Redistributable ANGLE libraries";
    homepage = "https://github.com/Comfy-Org/comfy-angle";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    inherit (comfyui.meta) maintainers;
  };
})
