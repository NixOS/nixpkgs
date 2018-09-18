{ stdenv, fetchurl, meson, ninja, vala, gobjectIntrospection, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, gettext, itstool, python3, libxml2, libgnome-games-support, libgee }:

stdenv.mkDerivation rec {
  name = "gnome-mines-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mines/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "16w55hqaxipcv870n9gpn6qiywbqbyg7bjshaa02r75ias8dfxvf";
  };

  # gobjectIntrospection for finding vapi files
  nativeBuildInputs = [ meson ninja vala gobjectIntrospection pkgconfig gettext itstool python3 libxml2 wrapGAppsHook ];
  buildInputs = [ gtk3 librsvg gnome3.defaultIconTheme libgnome-games-support libgee ];

  postPatch = ''
    chmod +x data/meson_compile_gschema.py # patchShebangs requires executable file
    patchShebangs data/meson_compile_gschema.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-mines";
      attrPath = "gnome3.gnome-mines";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Mines;
    description = "Clear hidden mines from a minefield";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
