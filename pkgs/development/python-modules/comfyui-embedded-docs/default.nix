{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-embedded-docs";
  version = "0.5.11";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_embedded_docs";
    inherit (finalAttrs) version;
    hash = "sha256-HetjmoWqXFY7ULa+ImvTPbG7OpeReI0sP7TYiMwv2n0=";
  };

  build-system = [ setuptools ];

  # Package only ships static Markdown documentation; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_embedded_docs" ];

  meta = {
    description = "Embedded node documentation for ComfyUI";
    homepage = "https://github.com/Comfy-Org/embedded-docs";
    license = lib.licenses.gpl3Only;
    inherit (comfyui.meta) maintainers;
  };
})
