{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  deepin-gettext-tools,
  wrapQtAppsHook,
  wrapGAppsHook3,
  alsa-lib,
  gtk3,
  libcanberra,
  libgudev,
  librsvg,
  poppler,
  pulseaudio,
  gdk-pixbuf-xlib,
  coreutils,
  dbus,
}:

buildGoModule rec {
  pname = "dde-api";
  version = "6.0.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-VpZwVNXxdi8ODwxbksQpT0nnUuLOTJ9h0JYucEKdGYM=";
  };

  vendorHash = "sha256-zrtUsCF2+301DKwgWectw+UbOehOp8h8u/IMf09XQ8Q=";

  postPatch = ''
    substituteInPlace misc/systemd/system/deepin-shutdown-sound.service \
      --replace-fail "/usr/bin/true" "${coreutils}/bin/true"

    substituteInPlace sound-theme-player/main.go \
      --replace-fail "/usr/sbin/alsactl" "alsactl"

    substituteInPlace misc/{scripts/deepin-boot-sound.sh,systemd/system/deepin-login-sound.service} \
      --replace-fail "/usr/bin/dbus-send" "${dbus}/bin/dbus-send"

    substituteInPlace lunar-calendar/huangli.go adjust-grub-theme/main.go \
      --replace-fail "/usr/share/dde-api" "$out/share/dde-api"

    substituteInPlace themes/{theme.go,settings.go} \
      --replace-fail "/usr/share" "/run/current-system/sw/share"

    for file in $(grep "/usr/lib/deepin-api" * -nR |awk -F: '{print $1}')
    do
      sed -i 's|/usr/lib/deepin-api|/run/current-system/sw/lib/deepin-api|g' $file
    done
  '';

  nativeBuildInputs = [
    pkg-config
    deepin-gettext-tools
    wrapQtAppsHook
    wrapGAppsHook3
  ];
  dontWrapGApps = true;

  buildInputs = [
    alsa-lib
    gtk3
    libcanberra
    libgudev
    librsvg
    poppler
    pulseaudio
    gdk-pixbuf-xlib
  ];

  buildPhase = ''
    runHook preBuild
    make GOBUILD_OPTIONS="$GOFLAGS"
    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall
    make install DESTDIR="$out" PREFIX="/"
    runHook postInstall
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    for binary in $out/lib/deepin-api/*; do
      wrapProgram $binary "''${qtWrapperArgs[@]}"
    done
  '';

  meta = with lib; {
    description = "Dbus interfaces used for screen zone detecting, thumbnail generating, sound playing, etc";
    mainProgram = "dde-open";
    homepage = "https://github.com/linuxdeepin/dde-api";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
