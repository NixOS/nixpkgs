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
, wrapGAppsHook3
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
  version = "6.2.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    rev = version;
    hash = "sha256-u5QsUFRXPVsk9T7tVmuOpTaAxdMIJs5yPVcWM1olXz8=";
  };

  patches = [
    ./use-sane-install-dir.patch
    ./libdir.patch
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
    wrapGAppsHook3
    intltool
    gtk-doc
    perl
    python3.pkgs.wrapPython
    pkg-config
  ];

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
      substituteInPlace ./bin/capi.py                     --replace-fail '"/usr/lib"' '"${cinnamon-control-center}/lib"'
      substituteInPlace ./bin/SettingsWidgets.py          --replace-fail "/usr/share/sounds" "/run/current-system/sw/share/sounds"
      substituteInPlace ./bin/Spices.py                   --replace-fail "subprocess.run(['/usr/bin/" "subprocess.run(['" \
                                                          --replace-fail 'subprocess.run(["/usr/bin/' 'subprocess.run(["' \
                                                          --replace-fail "msgfmt" "${gettext}/bin/msgfmt"
      substituteInPlace ./modules/cs_info.py              --replace-fail "lspci" "${pciutils}/bin/lspci"
      substituteInPlace ./modules/cs_keyboard.py          --replace-fail "/usr/bin/cinnamon-dbus-command" "$out/bin/cinnamon-dbus-command"
      substituteInPlace ./modules/cs_themes.py            --replace-fail "$out/share/cinnamon/styles.d" "/run/current-system/sw/share/cinnamon/styles.d"
    popd

    substituteInPlace ./files/usr/bin/cinnamon-session-{cinnamon,cinnamon2d} \
      --replace-fail "exec cinnamon-session" "exec ${cinnamon-session}/bin/cinnamon-session"

    patchShebangs src/data-to-c.pl
  '';

  postInstall = ''
    # Use locales from cinnamon-translations.
    ln -s ${cinnamon-translations}/share/locale $out/share/locale
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
    providedSessions = [ "cinnamon" "cinnamon2d" "cinnamon-wayland" ];
  };

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon";
    description = "Cinnamon desktop environment";
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
