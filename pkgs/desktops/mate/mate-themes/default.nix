{ stdenv, fetchurl, pkgconfig, intltool, mate, gtk2, gtk3,
  gtk_engines, gtk-engine-murrine, gdk-pixbuf, librsvg }:

stdenv.mkDerivation rec {
  pname = "mate-themes";
  version = "3.22.20";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/themes/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0c3dhf8p9nc2maky4g9xr04iil9wwbdkmhpzynlc6lfg4ksqq2bx";
  };

  nativeBuildInputs = [ pkgconfig intltool gtk3 ];

  buildInputs = [ mate.mate-icon-theme gtk2 gtk_engines gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postInstall = ''
    gtk-update-icon-cache "$out"/share/icons/ContrastHigh
  '';

  meta = {
    description = "A set of themes from MATE";
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
