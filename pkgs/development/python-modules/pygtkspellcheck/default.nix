{ lib, buildPythonPackage, fetchPypi, gobject-introspection, gtk3, pyenchant, pygobject3 }:

buildPythonPackage rec {
  pname = "pygtkspellcheck";
  version = "4.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pc3xmv1q775hn4kc1kspvpdn4gm7ix3aw6hz9iy3brfcw6ddcl4";
  };

  nativeBuildInputs = [ gobject-introspection gtk3 ];
  propagatedBuildInputs = [ pyenchant pygobject3 ];

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "gtkspellcheck" ];

  meta = with lib; {
    homepage = "https://github.com/koehlma/pygtkspellcheck";
    description = "A Python spell-checking library for GtkTextViews based on Enchant";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
