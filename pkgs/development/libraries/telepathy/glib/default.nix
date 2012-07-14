{ stdenv, fetchurl, dbus_glib, glib, python, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.18.1";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "0vac5wk9rpaniqxwa50szcc5ql779ks37sy4z7fj4k73i5k2af1p";
  };

  propagatedBuildInputs = [dbus_glib glib python];
  
  buildInputs = [pkgconfig libxslt];

  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
