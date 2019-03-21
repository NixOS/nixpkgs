{ stdenv, fetchurl, meson, ninja, vala, gobject-introspection, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, gettext, itstool, python3, libxml2, libgnome-games-support, libgee }:

stdenv.mkDerivation rec {
  name = "gnome-mines-${version}";
  version = "3.30.1.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mines/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "08ddk400sg1g3q26gnm5mgv81vdqyix0yl7pd47p50vkc1w6f33z";
  };

  # gobject-introspection for finding vapi files
  nativeBuildInputs = [ meson ninja vala gobject-introspection pkgconfig gettext itstool python3 libxml2 wrapGAppsHook ];
  buildInputs = [ gtk3 librsvg gnome3.adwaita-icon-theme libgnome-games-support libgee ];

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
