{
  atk,
  cacert,
  dbus,
  cinnamon-control-center,
  cinnamon-desktop,
  cinnamon-menus,
  cinnamon-session,
  cinnamon-translations,
  cjs,
  evolution-data-server,
  fetchFromGitHub,
  fetchpatch,
  gdk-pixbuf,
  gettext,
  libgnomekbd,
  glib,
  gobject-introspection,
  gsound,
  gtk3,
  intltool,
  json-glib,
  callPackage,
  libstartup_notification,
  libXtst,
  libXdamage,
  mesa,
  muffin,
  networkmanager,
  pkg-config,
  polkit,
  lib,
  stdenv,
  wrapGAppsHook3,
  libxml2,
  gtk-doc,
  gnome,
  python3,
  keybinder3,
  cairo,
  xapp,
  upower,
  nemo,
  libnotify,
  accountsservice,
  gnome-online-accounts,
  glib-networking,
  pciutils,
  timezonemap,
  libnma,
  meson,
  ninja,
  gst_all_1,
  perl,
}:

let
  pythonEnv = python3.withPackages (
    pp: with pp; [
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
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "cinnamon-common";
  version = "6.0.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon";
    rev = version;
    hash = "sha256-I0GJv2lcl5JlKPIiWoKMXTf4OLkznS5MpiOIvZ76bJQ=";
  };

  patches = [
    ./use-sane-install-dir.patch
    ./libdir.patch

    # Switch to GNOME Online Accounts GTK
    (fetchpatch {
      url = "https://github.com/linuxmint/cinnamon/commit/d22f889c376734f0ca5d904885c2772e790fbadc.patch";
      includes = [ "files/usr/share/cinnamon/cinnamon-settings/cinnamon-settings.py" ];
      hash = "sha256-xutJqxtzk3/BUQGZY/tnBkRyAfZZY7AckaGC6b7Sfn8=";
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
      substituteInPlace ./bin/capi.py                     --replace '"/usr/lib"' '"${cinnamon-control-center}/lib"'
      substituteInPlace ./bin/SettingsWidgets.py          --replace "/usr/share/sounds" "/run/current-system/sw/share/sounds"
      substituteInPlace ./bin/Spices.py                   --replace "subprocess.run(['/usr/bin/" "subprocess.run(['" \
                                                          --replace 'subprocess.run(["/usr/bin/' 'subprocess.run(["' \
                                                          --replace "msgfmt" "${gettext}/bin/msgfmt"
      substituteInPlace ./modules/cs_info.py              --replace "lspci" "${pciutils}/bin/lspci"
      substituteInPlace ./modules/cs_themes.py            --replace "$out/share/cinnamon/styles.d" "/run/current-system/sw/share/cinnamon/styles.d"
    popd

    sed "s| cinnamon-session| ${cinnamon-session}/bin/cinnamon-session|g" -i ./files/usr/bin/cinnamon-session-{cinnamon,cinnamon2d}

    patchShebangs src/data-to-c.pl
  '';

  postInstall = ''
    # Use locales from cinnamon-translations.
    ln -s ${cinnamon-translations}/share/locale $out/share/locale

    # Do not install online accounts module, with a -Donlineaccounts=false c-c-c
    # this just shows an empty page.
    rm -f $out/share/cinnamon/cinnamon-settings/modules/cs_online_accounts.py

    # g-o-a-gtk already provides its own desktop item.
    rm -f $out/share/applications/cinnamon-settings-online-accounts.desktop

    # Actually removes Adwaita and HighContrast from Cinnamon styles with mint-artwork 1.8.2.
    # https://github.com/linuxmint/cinnamon/commit/13b1ad104e88197f6c4e2d02ab2674c07254b8e8
    rm -r $out/share/cinnamon/styles.d
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
    providedSessions = [
      "cinnamon"
      "cinnamon2d"
      "cinnamon-wayland"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon";
    description = "The Cinnamon desktop environment";
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
