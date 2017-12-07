{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libxklavier }:

stdenv.mkDerivation rec {
  name = "libmatekbd-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "030bl18qbjm7l92bp1bhs7v82bp8j3mv7c1j1a4gd89iz4611pq3";
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
