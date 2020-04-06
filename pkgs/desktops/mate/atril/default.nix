{ stdenv, fetchurl, pkgconfig, gettext, gtk3, glib, libxml2, libsecret, poppler, itstool, hicolor-icon-theme, texlive, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "atril";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0967gxw7h2qh2kpwl0jgv58hicz6aa92kr12mnykbpikad25s95y";
  };

  nativeBuildInputs = [
    pkgconfig
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
    texlive.bin.core  # for synctex, used by the pdf back-end
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [ "cajaextensiondir=$$out/lib/caja/extensions-2.0" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A simple multi-page document viewer for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
