{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils, librsvg, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "mate-icon-theme";
  version = "1.22.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0r2bk4flb6kjj97badj2lnml4lfwpl2ym5hkf7r6f7cj8g6pzc4r";
  };

  nativeBuildInputs = [ pkgconfig intltool iconnamingutils ];

  buildInputs = [ librsvg ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    for theme in "$out"/share/icons/*; do
      "${gtk3.out}/bin/gtk-update-icon-cache" "$theme"
    done
  '';

  meta = {
    description = "Icon themes from MATE";
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
