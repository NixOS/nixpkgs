{ stdenv, fetchurl, pkgconfig, intltool, gtk3, mate, libxklavier }:

stdenv.mkDerivation rec {
  name = "libmatekbd-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1l1zbphs4snswf4bkrwkk6gsmb44bdhymcfgaaspzbrcmw3y7hr1";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gtk3 libxklavier ];

  meta = with stdenv.lib; {
    description = "Keyboard management library for MATE";
    homepage = https://github.com/mate-desktop/libmatekbd;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
