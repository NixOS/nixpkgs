{ stdenv, fetchurl, pkgconfig, glib, python }:

stdenv.mkDerivation rec {
  name = "libqmi-1.12.6";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/libqmi/${name}.tar.xz";
    sha256 = "101ppan2q1h4pyp2zbn9b8sdwy2c7fk9rp91yykxz3afrvzbymq8";
  };

  outputs = [ "out" "dev" "devdoc" ];

  preBuild = ''
    patchShebangs .
  '';

  buildInputs = [ pkgconfig glib python ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/libqmi/;
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ wkennington ];
  };
}
