{ stdenv, fetchurl, pkgconfig, intltool, gtk3, libxml2, libsecret, poppler, itstool, hicolor-icon-theme, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "atril-${version}";
  version = "1.20.3";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "00vrqyfk370fdhlfv3m6n0l6hnx30hrsrcg1xja03957cgvcvnvr";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    itstool
    libsecret
    libxml2
    poppler
    mate.caja
    mate.mate-desktop
    hicolor-icon-theme
  ];
  
  makeFlags = [ "cajaextensiondir=$$out/lib/caja/extensions-2.0" ];

  meta = {
    description = "A simple multi-page document viewer for the MATE desktop";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
