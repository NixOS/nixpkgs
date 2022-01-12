{ lib, stdenv, fetchurl, meson, ninja, pkg-config, gettext, libxml2, gobject-introspection, gnome, glib }:

stdenv.mkDerivation rec {
  pname = "totem-pl-parser";
  version = "3.26.6";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "wN8PaNXPnX2kPIHH8T8RFYNYNo+Ywi1Hci870EvTrBw=";
  };

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config gettext glib gobject-introspection ];
  buildInputs = [ libxml2 glib ];

  mesonFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dintrospection=false"
  ];

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Videos";
    description = "Simple GObject-based library to parse and save a host of playlist formats";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
