{ stdenv, fetchurl, dbus_glib, glib, python, pkgconfig, libxslt
, gobjectIntrospection, valaSupport ? true, vala }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.22.0";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "0mqrq2azw70rm50vy21acfnzn8mmh0w7dxh87mwr1lyk0jn1n232";
  };

  configureFlags = stdenv.lib.optional valaSupport "--enable-vala-bindings";

  propagatedBuildInputs = [dbus_glib glib python gobjectIntrospection];

  buildInputs = [pkgconfig libxslt] ++ stdenv.lib.optional valaSupport vala;

  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
