{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, gnome
, glib
, gtk4
, pango
, wrapGAppsHook4
, desktop-file-utils
, gobject-introspection
, gjs
, libunistring
, libadwaita
, gsettings-desktop-schemas
, gnome-desktop
}:

stdenv.mkDerivation rec {
  pname = "gnome-characters";
  version = "45.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "P9VPzBTSkbd//xLe7/8A2jg+CmQAr1B9FgX7y0m4x0E=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    desktop-file-utils
    wrapGAppsHook4
  ];


  buildInputs = [
    gjs
    glib
    gnome-desktop # for typelib
    gsettings-desktop-schemas
    gtk4
    libunistring
    libadwaita
    pango
  ];

  dontWrapGApps = true;

  postFixup = ''
    # Fixes https://github.com/NixOS/nixpkgs/issues/31168
    file="$out/share/org.gnome.Characters/org.gnome.Characters"
    sed -e $"2iimports.package._findEffectiveEntryPointName = () => \'$(basename $file)\' " \
      -i $file
    wrapGApp "$file"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Characters";
    description = "Simple utility application to find and insert unusual characters";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
