{ stdenv
, lib
, buildPackages
, fetchurl
, pkg-config
, libxml2
, autoreconfHook
, gtk-doc
, glib
, gtk3
, enchant2
, icu
, vala
, gobject-introspection
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gspell";
  version = "1.12.1";

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "jsRPMgUuiW/N1JJuuBSjJuOaUEfiUe7HuQVvvZREsPE=";
  };

  patches = [
    # Extracted from: https://github.com/Homebrew/homebrew-core/blob/2a27fb86b08afc7ae6dff79cf64aafb8ecc93275/Formula/gspell.rb#L125-L149
    # Dropped the GTK_MAC_* changes since gtk-mac-integration is not needed since 1.12.1
    ./0001-Darwin-build-fix.patch
  ];

  nativeBuildInputs = [
    pkg-config
    vala
    gobject-introspection
    libxml2
    autoreconfHook
    gtk-doc
    glib
  ];

  buildInputs = [
    gtk3
    icu
  ];

  propagatedBuildInputs = [
    # required for pkg-config
    enchant2
  ];

  configureFlags = [
    "GLIB_COMPILE_RESOURCES=${lib.getDev buildPackages.glib}/bin/glib-compile-resources"
    "GLIB_MKENUMS=${lib.getDev buildPackages.glib}/bin/glib-mkenums"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "A spell-checking library for GTK applications";
    homepage = "https://wiki.gnome.org/Projects/gspell";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
