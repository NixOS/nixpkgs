{ lib, buildPythonPackage, fetchPypi, gobject-introspection, gtk3, pyenchant, pygobject3 }:

buildPythonPackage rec {
  pname = "pygtkspellcheck";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kfhoOLnKbA9jH4DUtQw0nATjK21pMNxyAOzYDLQkR4U=";
  };

  nativeBuildInputs = [ gobject-introspection ];
  propagatedBuildInputs = [ pyenchant pygobject3 gtk3 ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "gtkspellcheck" ];

  meta = with lib; {
    homepage = "https://github.com/koehlma/pygtkspellcheck";
    description = "A Python spell-checking library for GtkTextViews based on Enchant";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
