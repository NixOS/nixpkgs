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
, python3
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
  version = "43.rc";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "kGbkD+29l6cF1lt+psPCW4+w6Y6mndI+y13RLjGmCj8=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
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

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

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
