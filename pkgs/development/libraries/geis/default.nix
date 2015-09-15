{ enableX11 ? true
, stdenv, fetchurl, pkgconfig, xorg, xorgserver, python3, dbus_libs, frame, grail }:

stdenv.mkDerivation rec {
  name = "geis-${version}";
  version = "2.2.16";
  src = fetchurl {
    url = "https://launchpad.net/geis/trunk/${version}/+download/${name}.tar.xz";
    sha256 = "40a694092c79f325a2fbf8a9f301177bc91c364f4e637c2aa8963ad2a5aabbcf";
  };

  buildInputs = [ pkgconfig python3 dbus_libs frame grail ]
  ++ stdenv.lib.optional enableX11 [xorg.libX11 xorg.libXtst xorg.libXext xorg.libXi xorg.xorgserver];

  configureFlags = stdenv.lib.optional enableX11"--enable-x11";

  meta = {
    homepage = "https://launchpad.net/geis";
    description = "A library for applications and toolkit programmers which provides a consistent platform independent interface for any system-wide input gesture recognition mechanism";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
