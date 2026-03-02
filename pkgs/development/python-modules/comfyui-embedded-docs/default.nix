{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,

  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "comfyui-embedded-docs";
  version = "0.4.3";
  pyproject = true;

  # no tags on github
  src = fetchPypi {
    pname = "comfyui_embedded_docs";
    inherit version;
    hash = "sha256-HMKr+T65Bv50bb8caScbH1ACFrCgqg1IoIQhjOtxu6w=";
  };
  build-system = [ setuptools ];

  pythonImportsCheck = [ "comfyui_embedded_docs" ];

  meta = {
    description = "Embedded documentation for ComfyUI nodes";
    homepage = "https://github.com/Comfy-Org/embedded-docs/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jk
    ];
  };
}
