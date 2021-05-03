{ lib, stdenv, fetchurl, meson, ninja, vala, libxslt, pkg-config, glib, gtk3, gnome3, python3, dconf
, libxml2, gettext, docbook_xsl, wrapGAppsHook, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "dconf-editor";
  version = "3.38.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-ElPa2H5iE/vzE/+eydxDWKobECYfKAcsHcDgmXuS+DU=";
  };

  nativeBuildInputs = [
    meson ninja vala libxslt pkg-config wrapGAppsHook
    gettext docbook_xsl libxml2 gobject-introspection python3
  ];

  buildInputs = [ glib gtk3 dconf ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
