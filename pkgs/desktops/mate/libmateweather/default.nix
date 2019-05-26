{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libsoup, tzdata }:

stdenv.mkDerivation rec {
  name = "libmateweather-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1ribgcwl4ncfbcf9bkcbxrgc7yzajdnxg12837psngymkqswlp6a";
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
