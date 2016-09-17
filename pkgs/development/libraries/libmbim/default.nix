{ stdenv, fetchurl, pkgconfig, glib, python, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libmbim-1.12.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libmbim/${name}.tar.xz";
    sha256 = "0abv0h9c3kbw4bq1b9270sg189jcjj3x3wa91bj836ynwg9m34wl";
  };

  outputs = [ "out" "dev" "doc" ];

  preConfigure = ''
    patchShebangs .
  '';

  buildInputs = [ pkgconfig glib udev libgudev python ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/software/libmbim/;
    description = "Library for talking to WWAN modems and devices which speak the Mobile Interface Broadband Model (MBIM) protocol";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ wkennington ];
  };
}
