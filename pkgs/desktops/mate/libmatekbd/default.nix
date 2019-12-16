{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libxklavier }:

stdenv.mkDerivation rec {
  pname = "libmatekbd";
  version = "1.22.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
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
