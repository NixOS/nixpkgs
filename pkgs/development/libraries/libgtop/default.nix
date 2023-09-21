{ lib, stdenv
, fetchurl
, glib
, pkg-config
, perl
, gettext
, gobject-introspection
, gnome
, gtk-doc
, deterministic-uname
}:

stdenv.mkDerivation rec {
  pname = "libgtop";
  version = "2.41.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "Q+qa0T98r5gwPmQXKxkb6blrqzQLAZ3u7HIlHuFA/js=";
  };

  nativeBuildInputs = [
    # uname output embedded in https://gitlab.gnome.org/GNOME/libgtop/-/blob/master/src/daemon/Makefile.am
    deterministic-uname
    pkg-config
    gtk-doc
    perl
    gettext
    gobject-introspection
  ];

  propagatedBuildInputs = [
    glib
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "A library that reads information about processes and the running system";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
