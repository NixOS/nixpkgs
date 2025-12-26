{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  nss,
  xorg,
  desktop-file-utils,
  libpulseaudio,
  libgcrypt,
  dbus,
  systemd,
  udev,
  libGL,
  fontconfig,
  freetype,
  openssl,
  wayland,
  libdrm,
  harfbuzz,
  openldap,
  curl,
  nghttp2,
  libunwind,
  alsa-lib,
  libidn2,
  rtmpdump,
  libpsl,
  libkrb5,
  xkeyboard_config,
  libsForQt5,
  pkg-config,
  fetchFromGitHub,
  cmake,
  ninja,
  wireplumber,
  libportal,
  xdg-desktop-portal,
  opencv4WithoutCuda,
  pipewire,
  fetchgit,
}:
let
  wemeet-wayland-screenshare = stdenv.mkDerivation {
    pname = "wemeet-wayland-screenshare";
    version = "0-unstable-2025-05-31";

    src = fetchFromGitHub {
      owner = "xuwd1";
      repo = "wemeet-wayland-screenshare";
      rev = "7f338966e162612b09d838512b11af5901414d05";
      hash = "sha256-UtPcgEa+9KrF4CblC8D4oClvVJs+a5DWtwH/fD7puVs=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
    ];

    buildInputs = [
      wireplumber
      libportal
      xdg-desktop-portal
      libsForQt5.qtwayland
      opencv4WithoutCuda
      pipewire
      xorg.libXdamage
      xorg.libXrandr
      xorg.libX11
    ];

    dontWrapQtApps = true;

    meta = {
      description = "Hooked WeMeet that enables screenshare on Wayland";
      homepage = "https://github.com/xuwd1/wemeet-wayland-screenshare";
      license = lib.licenses.mit;
    };
  };

  # for mitigating file transfer crashes
  libwemeetwrap = stdenv.mkDerivation {
    pname = "libwemeetwrap";
    version = "0-unstable-2023-12-14";

    src = fetchgit {
      url = "https://aur.archlinux.org/wemeet-bin.git";
      rev = "8f03fbc4d5ae263ed7e670473886cfa1c146aecc";
      hash = "sha256-ExzLCIoLu4KxaoeWNhMXixdlDTIwuPiYZkO+XVK8X10=";
    };

    dontWrapQtApps = true;

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      openssl
      libpulseaudio
      xorg.libX11
    ];

    buildPhase = ''
      runHook preBuild

      read -ra openssl_args < <(pkg-config --libs openssl)
      read -ra libpulse_args < <(pkg-config --cflags --libs libpulse)
      # Comment out `-D WRAP_FORCE_SINK_HARDWARE` to disable the patch that forces wemeet detects sink as hardware sink
      $CC $CFLAGS -Wall -Wextra -fPIC -shared \
        "''${openssl_args[@]}" "''${libpulse_args[@]}" \
        -o libwemeetwrap.so wrap.c -D WRAP_FORCE_SINK_HARDWARE

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 ./libwemeetwrap.so $out/lib/libwemeetwrap.so

      runHook postInstall
    '';

    meta.license = lib.licenses.unfree;
  };

  # Fix for Wayland crash when XSetInputFocus is called
  wemeet-x11-fix = stdenv.mkDerivation {
    pname = "wemeet-x11-fix";
    version = "0-unstable-2025-11-07";

    src = ./wemeet-x11-fix.c;

    dontUnpack = true;
    dontWrapQtApps = true;

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      xorg.libX11
    ];

    buildPhase = ''
      runHook preBuild

      $CC $CFLAGS -Wall -Wextra -fPIC -shared \
        -o libwemeet-x11-fix.so $src \
        -ldl -lX11

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 ./libwemeet-x11-fix.so $out/lib/libwemeet-x11-fix.so

      runHook postInstall
    '';

    meta = {
      description = "Fix for wemeet Wayland XSetInputFocus crash";
      license = lib.licenses.mit;
    };
  };

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system}
      or (throw "wemeet: ${stdenv.hostPlatform.system} is not supported");
in
stdenv.mkDerivation {
  pname = "wemeet";
  version = "3.26.10.401";

  src = selectSystem {
    x86_64-linux = fetchurl {
      url = "https://updatecdn.meeting.qq.com/cos/72e0e0023e1d1e6d4123fba28821aea1/TencentMeeting_0300000000_3.26.10.401_x86_64_default.publish.officialwebsite.deb";
      hash = "sha256-cPN7ApIJwO+RvpgT7r9mUMbLmgD3xxhJAVh3Pi/mrK8=";
    };
    aarch64-linux = fetchurl {
      url = "https://updatecdn.meeting.qq.com/cos/c06d6bc4a3370dbfb2f43bbc6ff8969e/TencentMeeting_0300000000_3.26.10.401_arm64_default.publish.officialwebsite.deb";
      hash = "sha256-W50E1bmqJLPDU7FY0qNKPlh1z8A9Ez1Gc+NrHQhBwgI=";
    };
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    nss
    xorg.libX11
    xorg.libSM
    xorg.libICE
    xorg.libXtst
    desktop-file-utils
    libpulseaudio
    libgcrypt
    dbus
    systemd
    udev
    libGL
    fontconfig
    freetype
    openssl
    wayland
    libdrm
    harfbuzz
    openldap
    curl
    nghttp2
    libunwind
    alsa-lib
    libidn2
    rtmpdump
    libpsl
    libkrb5
    xkeyboard_config
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/app
    cp -r opt/wemeet $out/app/wemeet
    cp -r usr/share $out/share
    # bundled libcurl depends on openssl 1.1 which is not available in nixpkgs
    rm -f $out/app/wemeet/lib/libcurl.so
    substituteInPlace $out/share/applications/wemeetapp.desktop \
      --replace-fail "/opt/wemeet/wemeetapp.sh" "wemeet" \
      --replace-fail "/opt/wemeet/wemeet.svg" "wemeet"
    substituteInPlace $out/app/wemeet/bin/qt.conf \
      --replace-fail "Prefix = ../" "Prefix = $out/app/wemeet/lib"
    cp -r $out/app/wemeet/icons $out/share/icons || true
    install -Dm0644 $out/app/wemeet/wemeet.svg $out/share/icons/hicolor/scalable/apps/wemeet.svg
    ln -s $out/app/wemeet/bin/raw/xcast.conf $out/app/wemeet/bin/xcast.conf
    ln -s $out/app/wemeet/plugins $out/app/wemeet/lib/plugins
    ln -s $out/app/wemeet/resources $out/app/wemeet/lib/resources
    ln -s $out/app/wemeet/translations $out/app/wemeet/lib/translations

    runHook postInstall
  '';

  postInstall = selectSystem {
    x86_64-linux = ''
      # According to @mnixry:
      #   The thing is, it's a coroutine library that involves a series of low-level operations like stack and register restoration and saving, so there's quite a bit of code that looks like hand-written assembly.
      #   Then they apparently changed the usage of co_jump_to_link, but the registers used in the assembly weren't updated accordingly.
      #   And then under certain versions of libc/libcpp implementations, that original register happens to have a value, so the tests also pass.

      # cmp rdi, 0 -> cmp r12, 0, at co_jump_to_link to address coroutine context resume issue
      echo -ne '\x49\x83\xfc\x00' | dd of=$out/app/wemeet/lib/libwemeet_base.so bs=1 seek=$((0x94c833)) conv=notrunc
    '';
    aarch64-linux = ''
      # I don't know if aarch64-linux version needs similar patch, I don't have aarch64 device.
    '';
  };

  # set LP_NUM_THREADS limit the number of cores used by rendering
  # set XDG_SESSION_TYPE; unset WAYLAND_DISPLAY getting border shadows to work
  # set QT_STYLE_OVERRIDE solve the color of the font is not visible when using the included Qt
  # set IBUS_USE_PORTAL fix ibus
  preFixup =
    let
      baseWrapperArgs = [
        "--set LP_NUM_THREADS 2"
        "--set QT_STYLE_OVERRIDE fusion"
        "--set IBUS_USE_PORTAL 1"
        "--set XKB_CONFIG_ROOT ${xkeyboard_config}/share/X11/xkb"
        "--prefix LD_LIBRARY_PATH : $out/app/wemeet/lib:$out/translations:${xorg.libXext}/lib:${xorg.libXdamage}/lib:${opencv4WithoutCuda}/lib:${xorg.libXrandr}/lib"
        "--prefix PATH : $out/app/wemeet/bin"
        "--prefix QT_PLUGIN_PATH : $out/app/wemeet/plugins"
      ];
      commonWrapperArgs = baseWrapperArgs ++ [
        "--prefix LD_PRELOAD : ${libwemeetwrap}/lib/libwemeetwrap.so:${wemeet-x11-fix}/lib/libwemeet-x11-fix.so"
        "--run 'if [[ $XDG_SESSION_TYPE == \"wayland\" ]]; then export LD_PRELOAD=${wemeet-wayland-screenshare}/lib/wemeet/libhook.so\${LD_PRELOAD:+:$LD_PRELOAD}; fi'"
      ];
      xwaylandWrapperArgs = baseWrapperArgs ++ [
        "--set XDG_SESSION_TYPE x11"
        "--set QT_QPA_PLATFORM xcb"
        "--unset WAYLAND_DISPLAY"
        "--prefix LD_PRELOAD : ${libwemeetwrap}/lib/libwemeetwrap.so:${wemeet-wayland-screenshare}/lib/wemeet/libhook.so"
      ];
    in
    ''
      makeWrapper $out/app/wemeet/bin/wemeetapp $out/bin/wemeet \
        ${lib.concatStringsSep " " commonWrapperArgs}
      makeWrapper $out/app/wemeet/bin/wemeetapp $out/bin/wemeet-xwayland \
        ${lib.concatStringsSep " " xwaylandWrapperArgs}
    '';

  meta = {
    description = "Tencent Video Conferencing";
    homepage = "https://wemeet.qq.com";
    license = lib.licenses.unfree;
    mainProgram = "wemeet";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ wrvsrx ];
  };
}
