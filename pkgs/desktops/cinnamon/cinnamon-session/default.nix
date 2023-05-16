{ fetchFromGitHub
, cinnamon-desktop
, cinnamon-settings-daemon
, cinnamon-translations
, dbus-glib
, glib
, gsettings-desktop-schemas
, gtk3
, libcanberra
, libxslt
, makeWrapper
, meson
, ninja
, pkg-config
, python3
, lib
, stdenv
, systemd
, wrapGAppsHook
, xapp
, xorg
, libexecinfo
, pango
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-session";
<<<<<<< HEAD
  version = "5.8.1";
=======
  version = "5.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-NVoP1KYh/z96NKMi9LjL4RgkjJg32oSy5WHJ91+70DI=";
=======
    hash = "sha256-lyASp0jFwaPLPQ3Jnow6eTpUBybwhSEmQUK/20fsh7I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./0001-Use-dbus_glib-instead-of-elogind.patch
  ];

  buildInputs = [
    # meson.build
    gtk3
    glib
    libcanberra
    pango
    xorg.libX11
    xorg.libXext
    xapp
    xorg.libXau
    xorg.libXcomposite

    systemd

    xorg.libXtst
    xorg.libXrender
    xorg.xtrans

    # other (not meson.build)

    cinnamon-desktop
    cinnamon-settings-daemon
    dbus-glib
    glib
    gsettings-desktop-schemas
  ];

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook
    libexecinfo
    python3
    pkg-config
    libxslt
  ];

  mesonFlags = [
    # use locales from cinnamon-translations
    "--localedir=${cinnamon-translations}/share/locale"
  ];

  postPatch = ''
    chmod +x data/meson_install_schemas.py # patchShebangs requires executable file
    patchShebangs data/meson_install_schemas.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${cinnamon-desktop}/share"
      --prefix XDG_CONFIG_DIRS : "${cinnamon-settings-daemon}/etc/xdg"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-session";
    description = "The Cinnamon session manager";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
