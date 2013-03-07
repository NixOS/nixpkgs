{ stdenv, fetchurl, dbus_glib, glib, python, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.20.1";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "1dk1s977zv8c935jsiv7ll51a52rlwd7a6f8v7z8klzvc4zk9801";
  };

  propagatedBuildInputs = [dbus_glib glib python];

  buildInputs = [pkgconfig libxslt];

  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
