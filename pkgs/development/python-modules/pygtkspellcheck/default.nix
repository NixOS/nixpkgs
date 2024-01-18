{ lib
, buildPythonPackage
, fetchPypi
, gobject-introspection
, gtk3
, poetry-core
, pyenchant
, pygobject3
}:

buildPythonPackage rec {
  pname = "pygtkspellcheck";
  version = "5.0.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NzaxRXU3BTIcRO9nowEak+Vk+XYw8nBCsTl//e/qg6w=";
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

  pythonImportsCheck = [
    "gtkspellcheck"
  ];

  meta = with lib; {
    homepage = "https://github.com/koehlma/pygtkspellcheck";
    description = "A Python spell-checking library for GtkTextViews based on Enchant";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
