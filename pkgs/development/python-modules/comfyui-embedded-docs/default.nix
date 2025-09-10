{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,

  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "comfyui-embedded-docs";
  version = "0.2.6";
  pyproject = true;

  # no tags on github
  src = fetchPypi {
    pname = "comfyui_embedded_docs";
    inherit version;
    hash = "sha256-ild/PuIWvo3NbAjpZYxvJX/7np6B9A8NNt6bSZJJdWo=";
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
