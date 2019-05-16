{ stdenv, fetchurl, meson, ninja, vala, gobject-introspection, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, gettext, itstool, python3, libxml2, libgnome-games-support, libgee, desktop-file-utils }:

stdenv.mkDerivation rec {
  name = "gnome-mines-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mines/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "13ia8a7bmdnp1281lwp8nvdqqkclvg1n3pw4bbr2dgsrsswfkscj";
  };

  # gobject-introspection for finding vapi files
  nativeBuildInputs = [
    meson ninja vala gobject-introspection pkgconfig gettext itstool python3
    libxml2 wrapGAppsHook desktop-file-utils
  ];
  buildInputs = [ gtk3 librsvg gnome3.adwaita-icon-theme libgnome-games-support libgee ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
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
