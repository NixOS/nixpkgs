{ lib, stdenv, fetchurl, meson, ninja, pkg-config, glib, gobject-introspection, gnome
, webkitgtk, libsoup, libxml2, libarchive }:

stdenv.mkDerivation rec {
  pname = "libgepub";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "16dkyywqdnfngmwsgbyga0kl9vcnzczxi3lmhm27pifrq5f3k2n7";
  };

  doCheck = true;

  nativeBuildInputs = [ meson ninja pkg-config gobject-introspection ];
  buildInputs = [ glib webkitgtk libsoup libxml2 libarchive ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "GObject based library for handling and rendering epub documents";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
  };
}
