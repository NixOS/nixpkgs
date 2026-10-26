{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  gobject-introspection,
  gtk3,
  pycairo,
  pygobject3,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "gaphas";
  version = "5.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-XdawWTHzhWqWtiMmm1AYcjG0q/e5hJ9I9+7FKJhWNpY=";
  };

  nativeBuildInputs = [
    poetry-core
    gobject-introspection
  ];

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    pycairo
    pygobject3
    typing-extensions
  ];

  pythonImportsCheck = [ "gaphas" ];

  meta = {
    description = "GTK+ based diagramming widget";
    homepage = "https://github.com/gaphor/gaphas";
    changelog = "https://github.com/gaphor/gaphas/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
