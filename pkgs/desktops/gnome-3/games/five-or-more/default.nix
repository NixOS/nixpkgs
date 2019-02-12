{ stdenv, fetchurl, meson, ninja, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, libgnome-games-support, gettext, itstool, libxml2, python3 }:

stdenv.mkDerivation rec {
  name = "five-or-more-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/five-or-more/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "00d729p251kh96624i7qg2370r5mxwafs016i6hy01vsr71jzb9x";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext itstool libxml2 python3 wrapGAppsHook ];
  buildInputs = [
    gtk3 librsvg libgnome-games-support gnome3.defaultIconTheme
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "five-or-more";
      attrPath = "gnome3.five-or-more";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Five_or_more;
    description = "Remove colored balls from the board by forming lines";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
