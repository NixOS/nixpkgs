{ stdenv, fetchurl, pkgconfig, gettext, gtk3, libsoup, tzdata }:

stdenv.mkDerivation rec {
  pname = "libmateweather";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "094mnlczxq9crjj8z7dzs1zmwscdkbp54l3qjaf4a4bhd8lihv8d";
  };

  nativeBuildInputs = [ pkgconfig gettext ];

  buildInputs = [ gtk3 libsoup tzdata ];

  configureFlags = [
    "--with-zoneinfo-dir=${tzdata}/share/zoneinfo"
    "--enable-locations-compression"
  ];

  preFixup = "rm -f $out/share/icons/mate/icon-theme.cache";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library to access weather information from online services for MATE";
    homepage = "https://github.com/mate-desktop/libmateweather";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
