{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  caja,
  gtk3,
  glib,
  libxml2,
  libarchive,
  libsecret,
  poppler,
  mate-desktop,
  itstool,
  hicolor-icon-theme,
  texlive,
  wrapGAppsHook3,
  enableEpub ? true,
  webkitgtk_4_1,
  enableDjvu ? true,
  djvulibre,
  enablePostScript ? true,
  libspectre,
  enableXps ? true,
  libgxps,
  enableImages ? false,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "atril";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "ztRyX26bccTqY2dr/DzDvgnSnboIqnp6uXlk4LQ1UWI=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs =
    [
      caja
      gtk3
      glib
      itstool
      libarchive
      libsecret
      libxml2
      poppler
      mate-desktop
      hicolor-icon-theme
      texlive.bin.core # for synctex, used by the pdf back-end
    ]
    ++ lib.optionals enableDjvu [ djvulibre ]
    ++ lib.optionals enableEpub [ webkitgtk_4_1 ]
    ++ lib.optionals enablePostScript [ libspectre ]
    ++ lib.optionals enableXps [ libgxps ];

  configureFlags =
    [ ]
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
    description = "Simple multi-page document viewer for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
