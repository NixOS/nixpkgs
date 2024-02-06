{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, buildGoModule
, pkg-config
, deepin-gettext-tools
, wrapQtAppsHook
, wrapGAppsHook
, alsa-lib
, gtk3
, libcanberra
, libgudev
, librsvg
, poppler
, pulseaudio
, gdk-pixbuf-xlib
, coreutils
, dbus
}:

buildGoModule rec {
  pname = "dde-api";
  version = "6.0.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-kdf1CoZUyda6bOTW0WJTgaXYhocrjRU9ptj7i+k8aaQ=";
  };

  patches = [
    (fetchpatch {
      name = "modify_PKGBUILD_to_support_OBS.patch";
      url = "https://github.com/linuxdeepin/dde-api/commit/1399522d032c6c649db79a33348cdb1a233bc23a.patch";
      hash = "sha256-kSHnYaOxIvv7lAJnvxpSwyRDPyDxpAq9x+gJcBdU3T8=";
    })
  ];

  vendorHash = "sha256-4Yscw3QjWG1rlju6sMRHGn3dSe65b1nx10B3KeyAzBM=";

  postPatch = ''
    substituteInPlace misc/systemd/system/deepin-shutdown-sound.service \
      --replace "/usr/bin/true" "${coreutils}/bin/true"

    substituteInPlace sound-theme-player/main.go \
      --replace "/usr/sbin/alsactl" "alsactl"

    substituteInPlace misc/{scripts/deepin-boot-sound.sh,systemd/system/deepin-login-sound.service} \
     --replace "/usr/bin/dbus-send" "${dbus}/bin/dbus-send"

    substituteInPlace lunar-calendar/huangli.go adjust-grub-theme/main.go \
      --replace "/usr/share/dde-api" "$out/share/dde-api"

    substituteInPlace themes/{theme.go,settings.go} \
      --replace "/usr/share" "/run/current-system/sw/share"

    for file in $(grep "/usr/lib/deepin-api" * -nR |awk -F: '{print $1}')
    do
      sed -i 's|/usr/lib/deepin-api|/run/current-system/sw/lib/deepin-api|g' $file
    done
  '';

  nativeBuildInputs = [
    pkg-config
    deepin-gettext-tools
    wrapQtAppsHook
    wrapGAppsHook
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
    homepage = "https://github.com/linuxdeepin/dde-api";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
