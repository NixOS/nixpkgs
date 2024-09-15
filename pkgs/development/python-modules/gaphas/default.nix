{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  poetry-core,
  gobject-introspection,
  gtk3,
  pycairo,
  pygobject3,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "gaphas";
  version = "4.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cZ25AJliym2D9SOJAg9wrAIGp32gz3aTPNGRijlT1eo=";
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

  meta = with lib; {
    description = "GTK+ based diagramming widget";
    homepage = "https://github.com/gaphor/gaphas";
    changelog = "https://github.com/gaphor/gaphas/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
