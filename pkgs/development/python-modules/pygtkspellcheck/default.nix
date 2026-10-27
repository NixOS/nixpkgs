{
  lib,
  buildPythonPackage,
  fetchPypi,
  gobject-introspection,
  gtk3,
  poetry-core,
  pyenchant,
  pygobject3,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygtkspellcheck";
  version = "5.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ppPe/t4Eg2C2th596E9PydagQhttkIkirQUTz9YoDOM=";
  };

  nativeBuildInputs = [
    gobject-introspection
    poetry-core
  ];

  propagatedBuildInputs = [
    pyenchant
    pygobject3
    gtk3
  ];

  doCheck = false; # there are no tests

  pythonImportsCheck = [ "gtkspellcheck" ];

  meta = {
    homepage = "https://github.com/koehlma/pygtkspellcheck";
    description = "Python spell-checking library for GtkTextViews based on Enchant";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
})
