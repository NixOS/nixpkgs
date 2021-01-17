{ lib, stdenv, fetchurl, pkg-config, gettext, gtk3, libnotify, libxml2, libexif, exempi, mate, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "caja";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1cnfy481hcwjv3ia3kw0d4h7ga8cng0pqm3z349v4qcmfdapmqc0";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libnotify
    libxml2
    libexif
    exempi
    mate.mate-desktop
    hicolor-icon-theme
  ];

  patches = [
    ./caja-extension-dirs.patch
  ];

  configureFlags = [ "--disable-update-mimedb" ];

  enableParallelBuilding = true;

  meta = {
    description = "File manager for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = with lib.licenses; [ gpl2 lgpl2 ];
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
}
