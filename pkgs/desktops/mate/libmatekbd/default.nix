{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, gtk3, libxklavier }:

stdenv.mkDerivation rec {
  name = "libmatekbd-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1dsr7618c92mhwabwhgxqsfp7gnf9zrz2z790jc5g085dxhg13y8";
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
