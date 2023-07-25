{ stdenv
, lib
, fetchFromGitHub
, buildGoPackage
, wrapQtAppsHook
, wrapGAppsHook
, gtk3
, pkg-config
, deepin-gettext-tools
, alsa-lib
, go-dbus-factory
, go-gir-generator
, go-lib
, libcanberra
, libgudev
, librsvg
, poppler
, pulseaudio
, gdk-pixbuf-xlib
, dbus
, coreutils
, deepin-desktop-base
}:

buildGoPackage rec {
  pname = "dde-api";
  version = "5.5.32";

  goPackagePath = "github.com/linuxdeepin/dde-api";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-F+vEOSpysqVtjs8de5mCmeANuCbYUQ860ZHl5rwNYac=";
  };

  patches = [ ./0001-dont-set-PATH.patch ];

  postPatch = ''
    substituteInPlace lang_info/lang_info.go \
      --replace "/usr/share/i18n/language_info.json" "${deepin-desktop-base}/share/i18n/language_info.json"

    substituteInPlace misc/systemd/system/deepin-shutdown-sound.service \
      --replace "/usr/bin/true" "${coreutils}/bin/true"

    substituteInPlace sound-theme-player/main.go \
      --replace "/usr/sbin/alsactl" "alsactl"

    substituteInPlace misc/scripts/deepin-boot-sound.sh \
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

  goDeps = ./deps.nix;

  nativeBuildInputs = [
    pkg-config
    deepin-gettext-tools
    wrapQtAppsHook
    wrapGAppsHook
  ];
  dontWrapGApps = true;

  buildInputs = [
    go-dbus-factory
    go-gir-generator
    go-lib
    gtk3
    alsa-lib
    libcanberra
    libgudev
    librsvg
    poppler
    pulseaudio
    gdk-pixbuf-xlib
  ];

  buildPhase = ''
    runHook preBuild
    addToSearchPath GOPATH "${go-dbus-factory}/share/gocode"
    addToSearchPath GOPATH "${go-gir-generator}/share/gocode"
    addToSearchPath GOPATH "${go-lib}/share/gocode"
    make -C go/src/${goPackagePath}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install DESTDIR="$out" PREFIX="/" -C go/src/${goPackagePath}
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
