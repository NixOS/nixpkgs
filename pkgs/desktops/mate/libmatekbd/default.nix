{ lib, stdenv, fetchurl, pkg-config, gettext, gtk3, libxklavier, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "libmatekbd";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "17mcxfkvl14p04id3n5kbhpjwjq00c8wmbyciyy2hm7kwdln6zx8";
  };

  nativeBuildInputs = [ pkg-config gettext ];

  buildInputs = [ gtk3 libxklavier ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Keyboard management library for MATE";
    homepage = "https://github.com/mate-desktop/libmatekbd";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
