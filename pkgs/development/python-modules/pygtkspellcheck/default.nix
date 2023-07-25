{ lib, buildPythonPackage, fetchPypi, gobject-introspection, gtk3, pyenchant, pygobject3 }:

buildPythonPackage rec {
  pname = "pygtkspellcheck";
  version = "5.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hIHf1LBmFhPWN138jaAAOpmx+frbe6XM22+jG+OWcvw=";
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
