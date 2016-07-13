{ stdenv, fetchurl
, pkgconfig
, python3
, dbus_libs
, evemu
, frame
, grail
, libX11
, libXext
, libXi
, libXtst
, xorgserver
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "geis-${version}";
  version = "2.2.16";

  src = fetchurl {
    url = "https://launchpad.net/geis/trunk/${version}/+download/${name}.tar.xz";
    sha256 = "40a694092c79f325a2fbf8a9f301177bc91c364f4e637c2aa8963ad2a5aabbcf";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=pedantic";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python3 dbus_libs evemu frame grail libX11 libXext libXi libXtst xorgserver ];

  meta = {
    description = "A library for input gesture recognition";
    homepage = https://launchpad.net/geis;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
