{ stdenv, fetchurl, dbus_glib, glib, python, pkgconfig, libxslt
, gobjectIntrospection, valaSupport ? true, vala }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.24.1";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "1symyzbjmxvksn2ifdkk50lafjm2llf2sbmky062gq2pz3cg23cy";
  };

  configureFlags = stdenv.lib.optional valaSupport "--enable-vala-bindings";

  propagatedBuildInputs = [dbus_glib glib python gobjectIntrospection];

  buildInputs = [pkgconfig libxslt] ++ stdenv.lib.optional valaSupport vala;

  preConfigure = ''
    substituteInPlace telepathy-glib/telepathy-glib.pc.in --replace Requires.private Requires
  '';

  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
