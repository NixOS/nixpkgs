{ lib, stdenv
, meson
, fetchurl
, python3
, pkg-config
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
, gnome
, gspell
, perl
, itstool
, desktop-file-utils
, vala
}:

stdenv.mkDerivation rec {
  pname = "gedit";
  version = "40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gedit/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "149ngl9qw6h59546lir1pa7hvw23ppsnqlj9mfqphmmn5jl99qsm";
  };

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    meson
    ninja
    perl
    pkg-config
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
    updateScript = gnome.updateScript {
      packageName = "gedit";
      attrPath = "gnome.gedit";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Gedit";
    description = "Official text editor of the GNOME desktop environment";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
