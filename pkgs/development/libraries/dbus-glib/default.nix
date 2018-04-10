{ stdenv, fetchurl, pkgconfig, expat, gettext, libiconv, dbus, glib }:

stdenv.mkDerivation rec {
  name = "dbus-glib-0.108";

  src = fetchurl {
    url = "${meta.homepage}/releases/dbus-glib/${name}.tar.gz";
    sha256 = "0b307hw9j41npzr6niw1bs6ryp87m5yafg492gqwvsaj4dz0qd4z";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  nativeBuildInputs = [ pkgconfig gettext ];

  buildInputs = [ expat libiconv ];

  propagatedBuildInputs = [ dbus glib ];

  preConfigure = ''
    configureFlagsArray+=("--exec-prefix=$dev")
  '';

  doCheck = true;

  passthru = { inherit dbus glib; };

  meta = {
    homepage = http://dbus.freedesktop.org;
    license = with stdenv.lib.licenses; [ afl21 gpl2 ];
    description = "Obsolete glib bindings for D-Bus lightweight IPC mechanism";
    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
