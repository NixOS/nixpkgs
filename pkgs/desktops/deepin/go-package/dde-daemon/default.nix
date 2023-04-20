{ stdenv
, lib
, fetchFromGitHub
, substituteAll
, buildGoPackage
, pkg-config
, deepin-gettext-tools
, gettext
, python3
, wrapGAppsHook
, go-dbus-factory
, go-gir-generator
, go-lib
, dde-api
, ddcutil
, alsa-lib
, glib
, gtk3
, libgudev
, libinput
, libnl
, librsvg
, linux-pam
, libxcrypt
, networkmanager
, pulseaudio
, gdk-pixbuf-xlib
, tzdata
, xkeyboard_config
, runtimeShell
, xorg
, xdotool
, getconf
, dbus
}:

buildGoPackage rec {
  pname = "dde-daemon";
  version = "5.14.122";

  goPackagePath = "github.com/linuxdeepin/dde-daemon";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-KoYMv4z4IGBH0O422PuFHrIgDBEkU08Vepax+00nrGE=";
  };

  patches = [
    ./0001-fix-wrapped-name-for-verifyExe.patch
    ./0002-dont-set-PATH.patch
    ./0003-search-in-XDG-directories.patch
    (substituteAll {
      src = ./0004-aviod-use-hardcode-path.patch;
      inherit dbus;
    })
  ];

  postPatch = ''
    substituteInPlace dock/desktop_file_path.go \
      --replace "/usr/share" "/run/current-system/sw/share"

    substituteInPlace session/eventlog/{app_event.go,login_event.go} accounts/users/users_test.go \
      --replace "/bin/bash" "${runtimeShell}"

    substituteInPlace inputdevices/layout_list.go \
      --replace "/usr/share/X11/xkb" "${xkeyboard_config}/share/X11/xkb"

    substituteInPlace appearance/background/{background.go,custom_wallpapers.go} accounts/user.go bin/dde-system-daemon/wallpaper.go \
     --replace "/usr/share/wallpapers" "/run/current-system/sw/share/wallpapers"

    substituteInPlace appearance/manager.go timedate/zoneinfo/zone.go \
     --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"

    substituteInPlace accounts/image_blur.go grub2/modify_manger.go \
      --replace "/usr/lib/deepin-api" "/run/current-system/sw/lib/deepin-api"

    substituteInPlace accounts/user_chpwd_union_id.go \
      --replace "/usr/lib/dde-control-center" "/run/current-system/sw/lib/dde-control-center"

    for file in $(grep "/usr/lib/deepin-daemon" * -nR |awk -F: '{print $1}')
    do
      sed -i 's|/usr/lib/deepin-daemon|/run/current-system/sw/lib/deepin-daemon|g' $file
    done

    patchShebangs .
  '';

  goDeps = ./deps.nix;

  nativeBuildInputs = [
    pkg-config
    deepin-gettext-tools
    gettext
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    go-dbus-factory
    go-gir-generator
    go-lib
    dde-api
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
    addToSearchPath GOPATH "${go-dbus-factory}/share/gocode"
    addToSearchPath GOPATH "${go-gir-generator}/share/gocode"
    addToSearchPath GOPATH "${go-lib}/share/gocode"
    addToSearchPath GOPATH "${dde-api}/share/gocode"
    make -C go/src/${goPackagePath}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install DESTDIR="$out" PREFIX="/" -C go/src/${goPackagePath}
    runHook postInstall
  '';

  postFixup = ''
    for f in "$out"/lib/deepin-daemon/*; do
      echo "Wrapping $f"
      wrapGApp "$f"
    done
    mv $out/run/current-system/sw/lib/deepin-daemon/service-trigger $out/lib/deepin-daemon/
    rm -r $out/run
  '';

  meta = with lib; {
    description = "Daemon for handling the deepin session settings";
    homepage = "https://github.com/linuxdeepin/dde-daemon";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
