{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "glib-1.2.10";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v1.2/glib-1.2.10.tar.gz;
    md5 = "6fe30dad87c77b91b632def29dd69ef9";
  };
}
