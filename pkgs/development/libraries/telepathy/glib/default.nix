{ stdenv, fetchurl, dbus_glib, glib, python, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.17.7";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "1brzw0cqawcyh7rffzbmydzbymrrsmzf8rksgamiqpwsdvcnksxz";
  };

  propagatedBuildInputs = [dbus_glib glib python];
  
  buildInputs = [pkgconfig libxslt];

  patches = [ ./fix-pkgconfig.patch ];
  
  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
