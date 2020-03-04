{ stdenv, fetchurl, pkgconfig, gettext, gtk3, libxklavier }:

stdenv.mkDerivation rec {
  pname = "libmatekbd";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1sq7gwr9q3hq4q0vx32qqa68qcqf5by9mqyxnq6lwgaq8ydq16ab";
  };

  nativeBuildInputs = [ pkgconfig gettext ];

  buildInputs = [ gtk3 libxklavier ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Keyboard management library for MATE";
    homepage = "https://github.com/mate-desktop/libmatekbd";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
