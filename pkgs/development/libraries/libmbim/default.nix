{ stdenv, fetchurl, pkgconfig, glib, python, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libmbim-1.14.2";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libmbim/${name}.tar.xz";
    sha256 = "1krirl9881dnx7l29zhvagk2qlhi26vpvkzdifjklhrjhimzxji2";
  };

  outputs = [ "out" "dev" "man" ];

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
