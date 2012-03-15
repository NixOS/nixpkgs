{ stdenv, fetchurl, dbus_glib, glib, python, pkgconfig, libxslt }:

stdenv.mkDerivation rec {
  name = "telepathy-glib-0.17.5";

  src = fetchurl {
    url = "${meta.homepage}/releases/telepathy-glib/${name}.tar.gz";
    sha256 = "13gylgwgjp29zakzj5kb4h0j5zh30dsl8ch7hp3dp4nmy4vdj6h1";
  };

  propagatedBuildInputs = [dbus_glib glib python];
  
  buildInputs = [pkgconfig libxslt];

  patches = [ ./fix-pkgconfig.patch ];
  
  meta = {
    homepage = http://telepathy.freedesktop.org;
  };
}
