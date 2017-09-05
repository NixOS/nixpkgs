{ stdenv, fetchurl, dbus_glib, glib, python2, pkgconfig, libxslt
, gobjectIntrospection, valaSupport ? true, vala_0_23, glibcLocales }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.24.1";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "1symyzbjmxvksn2ifdkk50lafjm2llf2sbmky062gq2pz3cg23cy";
  };

  configureFlags = stdenv.lib.optional valaSupport "--enable-vala-bindings";
  LC_ALL = "en_US.UTF-8";
  propagatedBuildInputs = [dbus_glib glib gobjectIntrospection];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxslt glibcLocales python2 ] ++ stdenv.lib.optional valaSupport vala_0_23;

  preConfigure = ''
    substituteInPlace telepathy-glib/telepathy-glib.pc.in --replace Requires.private Requires
  '';

  passthru.python = python2;

  meta = {
    homepage = http://telepathy.freedesktop.org;
    platforms = stdenv.lib.platforms.unix;
  };
}
