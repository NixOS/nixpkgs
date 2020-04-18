{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, gettext
, gnome3
, glib
, gtk3
, pango
, wrapGAppsHook
, python3
, gobject-introspection
, gjs
, libunistring
, gsettings-desktop-schemas
, adwaita-icon-theme
, gnome-desktop
}:

stdenv.mkDerivation rec {
  pname = "gnome-characters";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0mqaxsa7hcmvid3zbzvxpfkp7s01ghiq6kaibmd3169axrr8ahql";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkgconfig
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
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Design/Apps/CharacterMap";
    description = "Simple utility application to find and insert unusual characters";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
