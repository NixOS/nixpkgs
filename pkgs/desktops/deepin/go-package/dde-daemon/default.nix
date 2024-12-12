{
  lib,
  fetchFromGitHub,
  substituteAll,
  buildGoModule,
  pkg-config,
  deepin-gettext-tools,
  gettext,
  python3,
  wrapGAppsHook3,
  ddcutil,
  alsa-lib,
  glib,
  gtk3,
  libgudev,
  libinput,
  libnl,
  librsvg,
  linux-pam,
  libxcrypt,
  networkmanager,
  pulseaudio,
  gdk-pixbuf-xlib,
  tzdata,
  xkeyboard_config,
  runtimeShell,
  dbus,
  util-linux,
  dde-session-ui,
  coreutils,
  lshw,
  dmidecode,
  systemd,
}:

buildGoModule rec {
  pname = "dde-daemon";
  version = "6.0.43";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-3BzFFlcNwNWNcysD3qRYfdyGaX7gW2XJZ4HzdGiK7jU=";
  };

  vendorHash = "sha256-3kUAaVXERqNZhBFytzVbWY6/a8M0jIkWrN+QHdWp1HU=";

  patches = [
    ./0001-dont-set-PATH.diff
    (substituteAll {
      src = ./0002-fix-custom-wallpapers-path.diff;
      inherit coreutils;
    })
    (substituteAll {
      src = ./0003-aviod-use-hardcode-path.diff;
      inherit dbus;
    })
  ];

  postPatch = ''
    substituteInPlace session/eventlog/{app_event.go,login_event.go} \
      --replace-fail "/bin/bash" "${runtimeShell}"

    substituteInPlace inputdevices/layout_list.go \
      --replace-fail "/usr/share/X11/xkb" "${xkeyboard_config}/share/X11/xkb"

    substituteInPlace accounts1/user.go \
      --replace-fail "/usr/share/wallpapers" "/run/current-system/sw/share/wallpapers"

    substituteInPlace timedate1/zoneinfo/zone.go \
      --replace-fail "/usr/share/dde" "$out/share/dde" \
      --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"

    substituteInPlace accounts1/image_blur.go grub2/modify_manger.go \
      --replace-fail "/usr/lib/deepin-api" "/run/current-system/sw/lib/deepin-api"

    substituteInPlace accounts1/user_chpwd_union_id.go \
      --replace-fail "/usr/lib/dde-control-center" "/run/current-system/sw/lib/dde-control-center"

    substituteInPlace system/uadp1/crypto.go \
      --replace-fail "/usr/share/uadp" "/var/lib/dde-daemon/uadp"

    for file in $(grep "/usr/lib/deepin-daemon" * -nR |awk -F: '{print $1}')
    do
      sed -i 's|/usr/lib/deepin-daemon|/run/current-system/sw/lib/deepin-daemon|g' $file
    done

    patchShebangs .
  '';

  nativeBuildInputs = [
    pkg-config
    deepin-gettext-tools
    gettext
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    ddcutil
    linux-pam
    libxcrypt
    alsa-lib
    glib
    libgudev
    gtk3
    gdk-pixbuf-xlib
    networkmanager
    libinput
    libnl
    librsvg
    pulseaudio
    tzdata
    xkeyboard_config
  ];

  buildPhase = ''
    runHook preBuild
    make GOBUILD_OPTIONS="$GOFLAGS"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install DESTDIR="$out" PREFIX="/"
    runHook postInstall
  '';

  doCheck = false;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          util-linux
          dde-session-ui
          glib
          lshw
          dmidecode
          systemd
        ]
      }"
    )
  '';

  postFixup = ''
    for binary in $out/lib/deepin-daemon/*; do
      if [ "$binary" == "$out/lib/deepin-daemon/service-trigger" ] ; then
        continue;
      fi
      wrapGApp $binary
    done
  '';

  meta = with lib; {
    description = "Daemon for handling the deepin session settings";
    homepage = "https://github.com/linuxdeepin/dde-daemon";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
