{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gettext,
  libxml2,
  gobject-introspection,
  gnome,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "totem-pl-parser";
  version = "3.26.6";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "wN8PaNXPnX2kPIHH8T8RFYNYNo+Ywi1Hci870EvTrBw=";
  };

  patches = [
    # Upstream MR: https://gitlab.gnome.org/GNOME/totem-pl-parser/-/merge_requests/46
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/totem-pl-parser/-/commit/f4f69c9b99095416aaed18a73f7486ad9eb04aa9.patch";
      sha256 = "sha256-Uya5fgFgauv5rIpVK3CDGCieyMus7VjcLMMe/vQ2WWY=";
    })
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    glib
    gobject-introspection
  ];
  buildInputs = [
    libxml2
    glib
  ];

  mesonFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dintrospection=false"
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/totem-pl-parser";
    description = "Simple GObject-based library to parse and save a host of playlist formats";
    maintainers = teams.gnome.members;
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}
