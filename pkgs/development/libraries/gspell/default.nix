{ stdenv
, fetchurl
, pkg-config
, libxml2
, glib
, gtk3
, enchant2
, icu
, vala
, gobject-introspection
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gspell";
  version = "1.9.1";

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1pdb4gbjrs8mk6r0ipw5vxyvzav1wvkjq46kiq53r3nyznfpdfyw";
  };

  nativeBuildInputs = [
    pkg-config
    vala
    gobject-introspection
    libxml2
  ];

  buildInputs = [
    glib
    gtk3
    icu
  ];

  propagatedBuildInputs = [
    # required for pkg-config
    enchant2
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "A spell-checking library for GTK applications";
    homepage = "https://wiki.gnome.org/Projects/gspell";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
