{ stdenv
, fetchPypi
, buildPythonPackage
, pkgconfig
, gtk3
, gobject-introspection
, pygtk
, pygobject3
, goocanvas2
, isPy3k
 }:

with stdenv.lib;

buildPythonPackage rec {
  pname = "GooCalendar";
  version = "0.4";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca3950c2728916d9fb703c886f3940ac9b76739f99ec840b0e1c2c282510e1ab";
  };
  nativeBuildInputs = [ pkgconfig gobject-introspection ];
  propagatedBuildInputs = [
    pygtk
    pygobject3
  ];
  buildInputs = [
    gtk3
    goocanvas2
  ];

  # No upstream tests available
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A calendar widget for GTK using PyGoocanvas.";
    homepage    = https://goocalendar.tryton.org/;
    license     = licenses.gpl2;
    maintainers = [ maintainers.udono ];
  };
}
