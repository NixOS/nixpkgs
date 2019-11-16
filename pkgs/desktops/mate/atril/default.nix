{ stdenv, fetchurl, pkgconfig, intltool, gtk3, glib, libxml2, libsecret, poppler, itstool, hicolor-icon-theme, mate, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "atril";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "11l78zkxszvsjr74cmk1wff5ycqrzd89y6k36rydv2rb5af2nsfw";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
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
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  makeFlags = [ "cajaextensiondir=$$out/lib/caja/extensions-2.0" ];

  meta = {
    description = "A simple multi-page document viewer for the MATE desktop";
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
