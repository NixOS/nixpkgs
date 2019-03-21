{ stdenv, fetchurl, pkgconfig, glib, python, udev, libgudev }:

stdenv.mkDerivation rec {
  name = "libmbim-1.16.2";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libmbim/${name}.tar.xz";
    sha256 = "0qmjvjbgs9m8qsaiq5arikzglgaas9hh1968bi7sy3905kp4yjgb";
  };

  outputs = [ "out" "dev" "man" ];

  preConfigure = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib udev libgudev python ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/software/libmbim/;
    description = "Library for talking to WWAN modems and devices which speak the Mobile Interface Broadband Model (MBIM) protocol";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
