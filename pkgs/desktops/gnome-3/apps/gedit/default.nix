{ stdenv, meson, fetchurl, python3
, pkgconfig, gtk3, glib, adwaita-icon-theme
, libpeas, gtksourceview4, gsettings-desktop-schemas
, wrapGAppsHook, ninja, libsoup, tepl
, gnome3, gspell, perl, itstool, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "gedit";
  version = "3.36.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "15s1almlhjlgl3m8lxg6jpzln8jhgdxxjr635a3b7cf58d35b1v8";
  };

  nativeBuildInputs = [
    pkgconfig wrapGAppsHook meson ninja
    python3 perl itstool desktop-file-utils
  ];

  buildInputs = [
    gtk3 glib
    adwaita-icon-theme libsoup
    libpeas gtksourceview4
    gsettings-desktop-schemas gspell
    tepl
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    chmod +x plugins/externaltools/scripts/gedit-tool-merge.pl
    patchShebangs build-aux/meson/post_install.py
    patchShebangs plugins/externaltools/scripts/gedit-tool-merge.pl
  '';

  # Reliably fails to generate gedit-file-browser-enum-types.h in time
  enableParallelBuilding = false;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gedit";
      attrPath = "gnome3.gedit";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Gedit";
    description = "Official text editor of the GNOME desktop environment";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
