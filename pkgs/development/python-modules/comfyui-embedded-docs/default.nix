{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-embedded-docs";
  version = "0.4.4";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_embedded_docs";
    inherit (finalAttrs) version;
    hash = "sha256-+ZoRloCC+TQtszf8BpFkqN6UT2Op9efoMZ+8TQZhedk=";
  };

  build-system = [ setuptools ];

  # Package only ships static Markdown documentation; no tests.
  doCheck = false;

  pythonImportsCheck = [ "comfyui_embedded_docs" ];

  meta = {
    description = "Embedded node documentation for ComfyUI";
    homepage = "https://github.com/Comfy-Org/embedded-docs";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ caniko ];
  };
})
