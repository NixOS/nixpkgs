{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyphen";
  version = "0.18.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-265vu+TwHLIGEItDVz2FfGcQe+nQ446xsI1voiEGNKc=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyphen" ];

  meta = {
    description = "Module to hyphenate text";
    homepage = "https://github.com/Kozea/Pyphen";
    changelog = "https://github.com/Kozea/Pyphen/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      gpl2
      lgpl21
      mpl20
    ];
  };
})
