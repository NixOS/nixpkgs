{ stdenv, fetchurl, intltool, gtk3, gnome3, librsvg, pkgconfig, pango, atk, gtk2
, gdk-pixbuf, hicolor-icon-theme }:

let
  pname = "gnome-themes-extra";
  version = "3.28";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "06aqg9asq2vqi9wr29bs4v8z2bf4manhbhfghf4nvw01y2zs0jvw";
  };

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [ gtk3 librsvg pango atk gtk2 gdk-pixbuf ];
  propagatedBuildInputs = [ gnome3.adwaita-icon-theme hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  postInstall = ''
    gtk-update-icon-cache "$out"/share/icons/HighContrast
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
