{ stdenv, fetchurl, pkgconfig, glib, python, udev }:

stdenv.mkDerivation rec {
  name = "libmbim-1.6.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libmbim/${name}.tar.xz";
    sha256 = "10mh1b8jfxg6y6nhr7swbi9wx4acjgvx1if7nhrw1ppd5apvvvz0";
  };

  preConfigure = ''
    for f in build-aux/mbim-codegen/*; do
       substituteInPlace $f --replace "/usr/bin/env python" "${python}/bin/python"
    done
  '';

  buildInputs = [ pkgconfig glib udev ];

  meta = with stdenv.lib; {
    description = "talking to WWAN modems and devices which speak the Mobile Interface Broadband Model (MBIM) protocol";
    platforms = platforms.linux;
  };
}
