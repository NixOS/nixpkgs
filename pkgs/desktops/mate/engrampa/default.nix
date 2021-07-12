{ lib, stdenv, fetchurl, pkg-config, gettext, itstool, libxml2, gtk3, file, mate, hicolor-icon-theme, wrapGAppsHook, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "engrampa";
  version = "1.24.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0x26djz73g3fjwzcpr7k60xb6qx5izhw7lf2ggn34iwpihl0sa7f";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    gtk3
    file #libmagic
    mate.caja
    hicolor-icon-theme
    mate.mate-desktop
  ];

  configureFlags = [
    "--with-cajadir=$$out/lib/caja/extensions-2.0"
    "--enable-magic"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "Archive Manager for MATE";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus lgpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
