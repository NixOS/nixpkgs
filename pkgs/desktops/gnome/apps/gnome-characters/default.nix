{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, gnome
, glib
, gtk3
, pango
, wrapGAppsHook
, python3
, gobject-introspection
, gjs
, libunistring
, libhandy
, gsettings-desktop-schemas
, adwaita-icon-theme
, gnome-desktop
}:

stdenv.mkDerivation rec {
  pname = "gnome-characters";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "0z2xa4w921bzpzj6gv88pvbrijcnnwni6jxynwz0ybaravyzaqha";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];


  buildInputs = [
    adwaita-icon-theme
    gjs
    glib
    gnome-desktop # for typelib
    gsettings-desktop-schemas
    gtk3
    libunistring
    libhandy
    pango
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  dontWrapGApps = true;

  # Fixes https://github.com/NixOS/nixpkgs/issues/31168
  postFixup = ''
    for file in $out/share/org.gnome.Characters/org.gnome.Characters \
       $out/share/org.gnome.Characters/org.gnome.Characters.BackgroundService
    do
      sed -e $"2iimports.package._findEffectiveEntryPointName = () => \'$(basename $file)\' " \
        -i $file

      wrapGApp "$file"
    done
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
