{ lib, stdenv, fetchurl, pkg-config, glib, intltool, json-glib, librest, libsoup, gnome, gnome-online-accounts, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "libzapojit";
  version = "0.0.3";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0zn3s7ryjc3k1abj4k55dr2na844l451nrg9s6cvnnhh569zj99x";
  };

  nativeBuildInputs = [ pkg-config intltool gobject-introspection ];
  propagatedBuildInputs = [ glib json-glib librest libsoup gnome-online-accounts ]; # zapojit-0.0.pc

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "GObject wrapper for the SkyDrive and Hotmail REST APIs";
    homepage = "https://gitlab.gnome.org/Archive/libzapojit";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
