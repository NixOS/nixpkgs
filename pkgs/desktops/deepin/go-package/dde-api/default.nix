{ stdenv
, lib
, fetchFromGitHub
, buildGoPackage
, replaceAll
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

  patches = [ ./0001-fix-PATH-for-NixOS.patch ];

  postPatch = replaceAll "/usr/lib/deepin-api" "/run/current-system/sw/lib/deepin-api"
    + replaceAll "/usr/share/i18n/language_info.json" "${deepin-desktop-base}/share/i18n/language_info.json"
    + replaceAll "/usr/bin/dbus-send" "${dbus}/bin/dbus-send"
    + replaceAll "/usr/bin/true" "${coreutils}/bin/true"
    + replaceAll "/usr/sbin/alsactl" "alsactl"
    + ''
    substituteInPlace lunar-calendar/huangli.go adjust-grub-theme/main.go \
      --replace "/usr/share/dde-api" "$out/share/dde-api"
    substituteInPlace themes/{theme.go,settings.go} \
      --replace "/usr/share" "/run/current-system/sw/share"
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
    GOPATH="$GOPATH:${go-dbus-factory}/share/gocode"
    GOPATH="$GOPATH:${go-gir-generator}/share/gocode"
    GOPATH="$GOPATH:${go-lib}/share/gocode"
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
