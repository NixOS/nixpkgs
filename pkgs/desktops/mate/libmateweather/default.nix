{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libsoup, tzdata }:

stdenv.mkDerivation rec {
  name = "libmateweather-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1q3rvmm533cgiif9hbdp6a92dm727g5i2dv5d8krfa0nl36i468y";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gtk3 libsoup tzdata ];

  configureFlags = [
    "--with-zoneinfo-dir=${tzdata}/share/zoneinfo"
    "--enable-locations-compression"
  ];

  preFixup = "rm -f $out/share/icons/mate/icon-theme.cache";

  meta = with stdenv.lib; {
    description = "Library to access weather information from online services for MATE";
    homepage = https://github.com/mate-desktop/libmateweather;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
