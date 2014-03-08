{ stdenv, fetchurl, dbus_glib, glib, python, pkgconfig, libxslt
, gobjectIntrospection, valaSupport ? true, vala }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.22.1";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "0vf2drh7g55nxyd0mxyn9sf99m981dagnvv9yc3q9f4k8x092a78";
  };

  configureFlags = stdenv.lib.optional valaSupport "--enable-vala-bindings";

  propagatedBuildInputs = [dbus_glib glib python gobjectIntrospection];

  buildInputs = [pkgconfig libxslt] ++ stdenv.lib.optional valaSupport vala;

  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
