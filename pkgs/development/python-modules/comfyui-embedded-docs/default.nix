{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,

  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "comfyui-embedded-docs";
  version = "0.5.4";
  pyproject = true;

  # no tags on github
  src = fetchPypi {
    pname = "comfyui_embedded_docs";
    inherit version;
    hash = "sha256-l9nGqG8uABMUWfcASoc+KA6AUjfjPQJp5hyHq2r1BiU=";
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
