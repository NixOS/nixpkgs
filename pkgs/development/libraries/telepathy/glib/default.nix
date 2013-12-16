{ stdenv, fetchurl, dbus_glib, glib, python, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.20.4";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "0v5izjmgm1phy51l2y5whfrgzqx8510lqp16d2y5hb21bp40g8y9";
  };

  propagatedBuildInputs = [dbus_glib glib python];

  buildInputs = [pkgconfig libxslt];

  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
