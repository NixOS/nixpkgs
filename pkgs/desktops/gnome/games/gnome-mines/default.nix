{ lib, stdenv, fetchurl, meson, ninja, vala, gobject-introspection, pkg-config, gnome, gtk3, wrapGAppsHook
, librsvg, gettext, itstool, python3, libxml2, libgnome-games-support, libgee, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "gnome-mines";
  version = "40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "NQLps/ccs7LnEcDmAZGH/rzCvKh349RW3KtwD3vjEnI=";
  };

  # gobject-introspection for finding vapi files
  nativeBuildInputs = [
    meson ninja vala gobject-introspection pkg-config gettext itstool python3
    libxml2 wrapGAppsHook desktop-file-utils
  ];
  buildInputs = [ gtk3 librsvg gnome.adwaita-icon-theme libgnome-games-support libgee ];

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-mines";
      attrPath = "gnome.gnome-mines";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Mines";
    description = "Clear hidden mines from a minefield";
    maintainers = teams.gnome.members;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
