{ stdenv, fetchurl, pkgconfig, expat, gettext, libiconv, dbus, glib }:

stdenv.mkDerivation rec {
  name = "dbus-glib-0.102";

  src = fetchurl {
    url = "${meta.homepage}/releases/dbus-glib/${name}.tar.gz";
    sha256 = "177j5p2vrvpmzk2xrrj6akn73kvpbvnmsjvlmca9l55qbdcfsr39";
  };

  nativeBuildInputs = [ pkgconfig gettext ];

  buildInputs = [ expat libiconv ];

  propagatedBuildInputs = [ dbus.libs glib ];

  doCheck = true;

  passthru = { inherit dbus glib; };

  meta = {
    homepage = http://dbus.freedesktop.org;
    license = with stdenv.lib.licenses; [ afl21 gpl2 ];
    description = "Obsolete glib bindings for D-Bus lightweight IPC mechanism";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
