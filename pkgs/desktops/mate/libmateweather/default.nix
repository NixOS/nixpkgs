{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libsoup, tzdata, mate }:

stdenv.mkDerivation rec {
  name = "libmateweather-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1c8mvydb0h7z3zn0qahwlp15z5wl6nrv24q4z7ldhm340jnxsvh7";
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
