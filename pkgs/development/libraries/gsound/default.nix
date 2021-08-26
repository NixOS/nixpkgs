{ lib, stdenv, fetchurl, pkg-config, glib, vala, libcanberra, gobject-introspection, libtool, gnome }:

stdenv.mkDerivation rec {
  pname = "gsound";
  version = "1.0.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "bba8ff30eea815037e53bee727bbd5f0b6a2e74d452a7711b819a7c444e78e53";
  };

  nativeBuildInputs = [ pkg-config gobject-introspection libtool vala ];
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
    platforms = platforms.linux;
  };
}
