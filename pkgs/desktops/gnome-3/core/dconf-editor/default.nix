{ stdenv, fetchurl, meson, ninja, vala, libxslt, pkgconfig, glib, gtk3, gnome3, python3
, libxml2, gettext, docbook_xsl, hicolor-icon-theme, wrapGAppsHook, gobject-introspection }:

let
  pname = "dconf-editor";
  version = "3.32.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1fmsmlh16njjm948grz20mzrsvb4wjj7pl1fvkrkxqi7mhr177gi";
  };

  nativeBuildInputs = [
    meson ninja vala libxslt pkgconfig wrapGAppsHook
    gettext docbook_xsl libxml2 gobject-introspection python3
    hicolor-icon-theme # for setup-hook
  ];

  buildInputs = [ glib gtk3 gnome3.dconf ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "${pname}";
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
