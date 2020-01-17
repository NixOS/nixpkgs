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
  version = "0.6";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c22c93e19b933d10d8ea1c67a67f485267af82175ef59419427dd39d1e3af18";
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
    homepage = https://goocalendar.tryton.org/;
    license = licenses.gpl2;
    maintainers = [ maintainers.udono ];
  };
}
