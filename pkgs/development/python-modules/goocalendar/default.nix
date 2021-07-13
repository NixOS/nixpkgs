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
  version = "0.7.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "318b3b7790ac9d6d98881eee3b676fc9c17fc15d21dcdaff486e3c303333b41a";
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
