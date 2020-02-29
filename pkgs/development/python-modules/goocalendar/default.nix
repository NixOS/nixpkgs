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
  version = "0.7.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "14m05pi1vwl7i8iv1wvc0r3450dlivsh85f4cyny08l869cr9lf1";
  };

  nativeBuildInputs = [
    pkgconfig
    gobject-introspection
  ];

  propagatedBuildInputs = [
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
    homepage = "https://goocalendar.tryton.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.udono ];
  };
}
