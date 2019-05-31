{ stdenv, fetchurl, pkgconfig, intltool, mate, gtk2, gtk3,
  gtk_engines, gtk-engine-murrine, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "mate-themes-${version}";
  version = "3.22.19";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/themes/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1ycb8b8r0s8d1h1477135mynr53s5781gdb2ap8xlvj2g58492wq";
  };

  nativeBuildInputs = [ pkgconfig intltool gtk3 ];

  buildInputs = [ mate.mate-icon-theme gtk2 gtk_engines gdk_pixbuf librsvg ];

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
