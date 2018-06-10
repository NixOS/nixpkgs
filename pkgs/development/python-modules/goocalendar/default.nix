{ stdenv
, fetchPypi
, buildPythonPackage
, pkgconfig
, gtk3
, gobjectIntrospection
, pygtk
, pygobject3
, goocanvas2
, isPy3k
 }:

with stdenv.lib;

buildPythonPackage rec {
  pname = "GooCalendar";
  version = "0.3";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p7qbcv06xipg48sgpdlqf72ajl3n1qlypcc0giyi1a72zpyf823";
  };
  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];
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
