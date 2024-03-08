{ lib, stdenv, fetchurl, pkg-config, glib, vala, libcanberra, gobject-introspection, libtool, gnome, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "gsound";
  version = "1.0.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "06l80xgykj7x1kqkjvcq06pwj2rmca458zvs053qc55x3sg06bfa";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ pkg-config meson ninja gobject-introspection libtool vala ];
  buildInputs = [ glib libcanberra ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Projects/GSound";
    description = "Small library for playing system sounds";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
