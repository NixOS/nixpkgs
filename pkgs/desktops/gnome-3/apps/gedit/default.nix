{ stdenv
, meson
, fetchurl
, python3
, pkgconfig
, gtk3
, glib
, adwaita-icon-theme
, libpeas
, gtksourceview4
, gsettings-desktop-schemas
, wrapGAppsHook
, ninja
, libsoup
, tepl
, gnome3
, gspell
, perl
, itstool
, desktop-file-utils
, vala
}:

stdenv.mkDerivation rec {
  pname = "gedit";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1y2n3325qvfiaz526vdf7l5wbh5js25djkz3jmg6x3z5dn00dks6";
  };

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    meson
    ninja
    perl
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    adwaita-icon-theme
    glib
    gsettings-desktop-schemas
    gspell
    gtk3
    gtksourceview4
    libpeas
    libsoup
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
