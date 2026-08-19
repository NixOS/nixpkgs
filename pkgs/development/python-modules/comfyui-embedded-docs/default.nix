{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-embedded-docs";
  version = "0.5.9";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_embedded_docs";
    inherit (finalAttrs) version;
    hash = "sha256-uz83lj91nLsqT4C/nHZdr1pfKI18FaFiU/dI2Dx9gZk=";
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
