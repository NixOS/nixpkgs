{ lib
, stdenv
, fetchurl
, fetchpatch
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
  version = "43.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "poW5y/k1Re05EWjEHJ2L+DeFq7+0iWdYJ+5zQkcbqsg=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-characters/-/commit/3e28a6ad668e2239b14f2e05bc477ec1bfb210ba.patch";
      sha256 = "sha256-2N4eewknhOXBABs6BPA5/YuqZMT8dyXW857iamrrtuA=";
    })
  ];

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
