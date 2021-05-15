{ lib
, fetchPypi
, buildPythonPackage
, pkg-config
, gtk3
, gobject-introspection
, pygobject3
, goocanvas2
, isPy3k
 }:

buildPythonPackage rec {
  pname = "GooCalendar";
  version = "0.7.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ccvw1w7xinl574h16hqs6dh3fkpm5n1jrqwjqz3ignxvli5sr38";
  };

  nativeBuildInputs = [
    pkg-config
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

  meta = with lib; {
    description = "A calendar widget for GTK using PyGoocanvas.";
    homepage = "https://goocalendar.tryton.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.udono ];
  };
}
