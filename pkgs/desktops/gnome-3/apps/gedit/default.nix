{ stdenv, meson, fetchurl, python3
, pkgconfig, gtk3, glib, adwaita-icon-theme
, libpeas, gtksourceview4, gsettings-desktop-schemas
, wrapGAppsHook, ninja, libsoup, libxml2
, gnome3, gspell, perl, itstool, desktop-file-utils }:

stdenv.mkDerivation rec {
  name = "gedit-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1lray9vvbcrnhjv5cr5fc4bqfd68km2x79cj50byyqn9cnlf5qn9";
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook meson ninja libxml2
    python3 perl itstool desktop-file-utils
  ];

  buildInputs = [
    gtk3 glib
    adwaita-icon-theme libsoup
    libpeas gtksourceview4
    gsettings-desktop-schemas gspell
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    chmod +x plugins/externaltools/scripts/gedit-tool-merge.pl
    patchShebangs build-aux/meson/post_install.py
    patchShebangs plugins/externaltools/scripts/gedit-tool-merge.pl
  '';

  mesonFlags = [
    "--buildtype=plain" # don't require git
  ];

  # Reliably fails to generate gedit-file-browser-enum-types.h in time
  enableParallelBuilding = false;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gedit";
      attrPath = "gnome3.gedit";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gedit;
    description = "Official text editor of the GNOME desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
