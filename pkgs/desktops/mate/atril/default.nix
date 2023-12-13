{ lib
, stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, pkg-config
, gtk-doc
, yelp-tools
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
, webkitgtk_4_1
, enableDjvu ? true
, djvulibre
, enablePostScript ? true
, libspectre
, enableXps ? true
, libgxps
, enableImages ? false
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "atril";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "pTphOsuXAaGK1nG/WQJU0c6Da6CuG+LAvYlI/fa0kaQ=";
  };



  patches = [
    # Use webkigtk 4.1 ABI.
    (fetchpatch {
      url = "https://github.com/mate-desktop/atril/commit/92f7d054d2a534bb08f92821e910625ecc0a3760.patch";
      hash = "sha256-8vFCgvs+ll+BHM6c/paPDulDWFkF4T1M/RAO8RCPYcc=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gtk-doc
    yelp-tools
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
  ++ lib.optionals enableDjvu [ djvulibre ]
  ++ lib.optionals enableEpub [ webkitgtk_4_1 ]
  ++ lib.optionals enablePostScript [ libspectre ]
  ++ lib.optionals enableXps [ libgxps ]
  ;

  configureFlags = [ ]
    ++ lib.optionals (enableDjvu) [ "--enable-djvu" ]
    ++ lib.optionals (enableEpub) [ "--enable-epub" ]
    ++ lib.optionals (enablePostScript) [ "--enable-ps" ]
    ++ lib.optionals (enableXps) [ "--enable-xps" ]
    ++ lib.optionals (enableImages) [ "--enable-pixbuf" ];

  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [ "cajaextensiondir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "A simple multi-page document viewer for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
