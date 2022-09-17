{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, gtk3
, glib
, libxml2
, libsecret
, poppler
, itstool
, hicolor-icon-theme
, texlive
, mate
, wrapGAppsHook
, enableEpub ? true
, webkitgtk
, enableDjvu ? true
, djvulibre
, enablePostScript ? true
, libspectre
, enableXps ? true
, libgxps
, enableImages ? false
, mateUpdateScript
}:

with lib;

stdenv.mkDerivation rec {
  pname = "atril";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0pz44k3axhjhhwfrfvnwvxak1dmjkwqs63rhrbcaagyymrp7cpki";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    glib
    itstool
    libsecret
    libxml2
    poppler
    mate.caja
    mate.mate-desktop
    hicolor-icon-theme
    texlive.bin.core # for synctex, used by the pdf back-end
  ]
  ++ optionals enableDjvu [ djvulibre ]
  ++ optionals enableEpub [ webkitgtk ]
  ++ optionals enablePostScript [ libspectre ]
  ++ optionals enableXps [ libgxps ]
  ;

  configureFlags = [ ]
    ++ optionals (enableDjvu) [ "--enable-djvu" ]
    ++ optionals (enableEpub) [ "--enable-epub" ]
    ++ optionals (enablePostScript) [ "--enable-ps" ]
    ++ optionals (enableXps) [ "--enable-xps" ]
    ++ optionals (enableImages) [ "--enable-pixbuf" ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [ "cajaextensiondir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "A simple multi-page document viewer for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
