{ lib, stdenv
, fetchurl
, glib
, pkg-config
, perl
, gettext
, gobject-introspection
, gnome
, gtk-doc
}:

stdenv.mkDerivation rec {
  pname = "libgtop";
  version = "2.40.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1m6jbqk8maa52gxrf223442fr5bvvxgb7ham6v039i3r1i62gwvq";
  };

  nativeBuildInputs = [
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
