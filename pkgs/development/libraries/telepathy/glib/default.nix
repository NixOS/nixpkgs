{ stdenv, fetchurl, dbus_glib, glib, python, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.22.0";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "0mqrq2azw70rm50vy21acfnzn8mmh0w7dxh87mwr1lyk0jn1n232";
  };

  propagatedBuildInputs = [dbus_glib glib python];

  buildInputs = [pkgconfig libxslt];

  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
