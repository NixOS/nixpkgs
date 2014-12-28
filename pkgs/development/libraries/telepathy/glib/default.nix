{ stdenv, fetchurl, dbus_glib, glib, python, pkgconfig, libxslt
, gobjectIntrospection, valaSupport ? true, vala }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.24.0";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "ae0002134991217f42e503c43dea7817853afc18863b913744d51ffa029818cf";
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
