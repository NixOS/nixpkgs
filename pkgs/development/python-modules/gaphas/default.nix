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

buildPythonPackage rec {
  pname = "gaphas";
  version = "5.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ifr1Ul9/IaIvZ6b2SU08o110lRXlZ6RoqkH3CRYcH5A=";
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
    changelog = "https://github.com/gaphor/gaphas/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
