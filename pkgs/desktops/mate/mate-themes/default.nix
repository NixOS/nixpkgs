{ lib, stdenv, fetchurl, pkg-config, gettext, mate-icon-theme, gtk2, gtk3,
  gtk_engines, gtk-engine-murrine, gdk-pixbuf, librsvg }:

stdenv.mkDerivation rec {
  pname = "mate-themes";
  version = "3.22.21";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/themes/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "051g2vq817g84yrqzf7hjcqr4xrghnw1rprjd6jf5mhhzmwcas6n";
  };

  nativeBuildInputs = [ pkg-config gettext gtk3 ];

  buildInputs = [ mate-icon-theme gtk2 gtk_engines gdk-pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontDropIconThemeCache = true;

  postInstall = ''
    gtk-update-icon-cache "$out"/share/icons/ContrastHigh
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A set of themes from MATE";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
}
