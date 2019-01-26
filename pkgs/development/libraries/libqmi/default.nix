{ stdenv, fetchurl, pkgconfig, glib, python, libgudev, libmbim }:

stdenv.mkDerivation rec {
  name = "libqmi-1.20.2";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/libqmi/${name}.tar.xz";
    sha256 = "0i6aw8jyxv84d5x8lj2g9lb8xxf1dyad8n3q0kw164pyig55jd67";
  };

  outputs = [ "out" "dev" "devdoc" ];

  preBuild = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib python libgudev libmbim ];

  configureFlags = ["--enable-mbim-qmux" ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/libqmi/;
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
