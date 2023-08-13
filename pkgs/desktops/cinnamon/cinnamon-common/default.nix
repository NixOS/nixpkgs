{ atk
, cacert
, dbus
, cinnamon-control-center
, cinnamon-desktop
, cinnamon-menus
, cinnamon-session
, cinnamon-translations
, cjs
, evolution-data-server
, fetchFromGitHub
, fetchpatch
, gdk-pixbuf
, gettext
, libgnomekbd
, glib
, gobject-introspection
, gsound
, gtk3
, intltool
, json-glib
, callPackage
, libsoup
, libstartup_notification
, libXtst
, libXdamage
, mesa
, muffin
, networkmanager
, pkg-config
, polkit
, lib
, stdenv
, wrapGAppsHook
, libxml2
, gtk-doc
, gnome
, python3
, keybinder3
, cairo
, xapp
, upower
, nemo
, libnotify
, accountsservice
, gnome-online-accounts
, glib-networking
, pciutils
, timezonemap
, libnma
, meson
, ninja
, gst_all_1
, perl
}:

let
  pythonEnv = python3.withPackages (pp: with pp; [
    dbus-python
    setproctitle
    pygobject3
    pycairo
    pp.xapp # don't omit `pp.`, see #213561
    pillow
    pyinotify # for looking-glass
    pytz
    tinycss2
    python-pam
    pexpect
    distro
    requests
  ]);
in
stdenv.mkDerivation rec {
  pname = "cinnamon-common";
  version = "5.8.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    rev = version;
    hash = "sha256-34kOSDIU56cSZ4j0FadVfr9HLQytnK4ys88DFF7LTiM=";
  };

  patches = [
    ./use-sane-install-dir.patch
    ./libdir.patch

    # Backport pillow 10.0.0 support.
    # https://github.com/linuxmint/cinnamon/issues/11746
    (fetchpatch {
      url = "https://github.com/linuxmint/cinnamon/commit/fce9aad1ebb290802dc550e8dae6344dddf9dec1.patch";
      hash = "sha256-flt7CblfXlLieAVNeC8TBnv1TX0Zca1obPWusBMnIxE=";
    })
  ];

  buildInputs = [
    atk
    cacert
    cinnamon-control-center
    cinnamon-desktop
    cinnamon-menus
    cjs
    dbus
    evolution-data-server # for calendar-server
    gdk-pixbuf
    glib
    gsound
    gtk3
    json-glib
    libsoup # referenced in js/ui/environment.js
    libstartup_notification
    libXtst
    libXdamage
    mesa
    muffin
    networkmanager
    polkit
    pythonEnv
    libxml2
    libgnomekbd
    gst_all_1.gstreamer

    # bindings
    cairo
    gnome.caribou
    keybinder3
    upower
    xapp
    timezonemap
    nemo
    libnotify
    accountsservice
    libnma

    # gsi bindings
    gnome-online-accounts
    glib-networking # for goa
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    wrapGAppsHook
    intltool
    gtk-doc
    perl
    python3.pkgs.wrapPython
    pkg-config
  ];

  # Use locales from cinnamon-translations.
  # FIXME: Upstream does not respect localedir option from Meson currently.
  # https://github.com/linuxmint/cinnamon/pull/11244#issuecomment-1305855783
  postInstall = ''
    ln -s ${cinnamon-translations}/share/locale $out/share/locale
  '';

  postPatch = ''
    find . -type f -exec sed -i \
      -e s,/usr/share/cinnamon,$out/share/cinnamon,g \
      -e s,/usr/share/locale,/run/current-system/sw/share/locale,g \
      {} +

    # All optional and may introduce circular dependency.
    find ./files/usr/share/cinnamon/applets -type f -exec sed -i \
      -e '/^#/!s,/usr/bin,/run/current-system/sw/bin,g' \
      {} +

    pushd ./files/usr/share/cinnamon/cinnamon-settings
      substituteInPlace ./bin/capi.py                     --replace '"/usr/lib"' '"${cinnamon-control-center}/lib"'
      substituteInPlace ./bin/CinnamonGtkSettings.py      --replace "'python3'" "'${pythonEnv.interpreter}'"
      substituteInPlace ./bin/SettingsWidgets.py          --replace "/usr/share/sounds" "/run/current-system/sw/share/sounds"
      substituteInPlace ./bin/Spices.py                   --replace "msgfmt" "${gettext}/bin/msgfmt"
      substituteInPlace ./modules/cs_info.py              --replace "lspci" "${pciutils}/bin/lspci"
      substituteInPlace ./modules/cs_themes.py            --replace "$out/share/cinnamon/styles.d" "/run/current-system/sw/share/cinnamon/styles.d"
    popd

    sed "s| cinnamon-session| ${cinnamon-session}/bin/cinnamon-session|g" -i ./files/usr/bin/cinnamon-session-{cinnamon,cinnamon2d}

    patchShebangs src/data-to-c.pl
  '';

  preFixup = ''
    # https://github.com/NixOS/nixpkgs/issues/101881
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome.caribou}/share"
    )

    buildPythonPath "$out ${python3.pkgs.xapp}"

    # https://github.com/NixOS/nixpkgs/issues/200397
    patchPythonScript $out/bin/cinnamon-spice-updater

    # https://github.com/NixOS/nixpkgs/issues/129946
    patchPythonScript $out/share/cinnamon/cinnamon-desktop-editor/cinnamon-desktop-editor.py

    # Called as `pkexec cinnamon-settings-users.py`.
    wrapGApp $out/share/cinnamon/cinnamon-settings-users/cinnamon-settings-users.py
  '';

  passthru = {
    providedSessions = [ "cinnamon" "cinnamon2d" ];
  };

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon";
    description = "The Cinnamon desktop environment";
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
