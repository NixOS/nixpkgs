{ lib
, stdenv
, fetchurl
, bash
, gnome
, meson
, python3
, ninja
}:

stdenv.mkDerivation rec {
  pname = "mm-common";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "cFxtKfQRaim95ONs/BsEbJK274xtrk6uyFAYdH5tpao=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    python3
    ninja
  ];

  # for shebangs
  buildInputs = [
    python3
    bash
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Common build files of GLib/GTK C++ bindings";
    longDescription = ''
      The mm-common module provides the build infrastructure and utilities
      shared among the GNOME C++ binding libraries. It is only a required
      dependency for building the C++ bindings from the gnome.org version
      control repository. An installation of mm-common is not required for
      building tarball releases, unless configured to use maintainer-mode.
    '';
    homepage = "https://www.gtkmm.org";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
