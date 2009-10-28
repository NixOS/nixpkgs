{stdenv, fetchurl, x11, glib}:

stdenv.mkDerivation {
  name = "gtk+-1.2.10";

  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v1.2/gtk+-1.2.10.tar.gz;
    md5 = "4d5cb2fc7fb7830e4af9747a36bfce20";
  };

  propagatedBuildInputs = [x11 glib];
}
