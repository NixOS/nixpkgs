{ lib, stdenv, fetchurl, meson, ninja, pkg-config, gettext, libxml2, gobject-introspection, gnome, glib }:

stdenv.mkDerivation rec {
  pname = "totem-pl-parser";
  version = "3.26.5";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "132jihnf51zs98yjkc6jxyqib4f3dawpjm17g4bj4j78y93dww2k";
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
