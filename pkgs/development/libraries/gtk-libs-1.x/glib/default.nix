{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "glib-1.2.10";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v1.2/glib-1.2.10.tar.gz;
    md5 = "6fe30dad87c77b91b632def29dd69ef9";
  };
  # Patch for gcc 3.4 compatibility.  Based on
  # http://cvs.openpkg.org/chngview?cn=16208.
  patches = [./gcc34.patch];
}
