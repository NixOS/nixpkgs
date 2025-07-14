{
  lib,
  stdenv,
  bash,
  fetchFromGitHub,
  fetchpatch,
  SDL2,
  alsa-lib,
  catch2_3,
  fftw,
  glib,
  gobject-introspection,
  gpsd,
  gtk-layer-shell,
  gtkmm3,
  iniparser,
  jsoncpp,
  libcava,
  libdbusmenu-gtk3,
  libevdev,
  libinotify-kqueue,
  libinput,
  libjack2,
  libmpdclient,
  libnl,
  libpulseaudio,
  libsigcxx,
  libxkbcommon,
  meson,
  ncurses,
  ninja,
  pipewire,
  pkg-config,
  playerctl,
  portaudio,
  python3,
  scdoc,
  sndio,
  spdlog,
  systemdMinimal,
  udev,
  upower,
  versionCheckHook,
  wayland,
  wayland-scanner,
  wireplumber,
  wrapGAppsHook3,

  cavaSupport ? true,
  enableManpages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  evdevSupport ? true,
  experimentalPatches ? true,
  gpsSupport ? true,
  inputSupport ? true,
  jackSupport ? true,
  mpdSupport ? true,
  mprisSupport ? stdenv.hostPlatform.isLinux,
  niriSupport ? true,
  nlSupport ? true,
  pipewireSupport ? true,
  pulseSupport ? true,
  rfkillSupport ? true,
  runTests ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  sndioSupport ? true,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal,
  traySupport ? true,
  udevSupport ? true,
  upowerSupport ? true,
  wireplumberSupport ? true,
  withMediaPlayer ? mprisSupport && false,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waybar";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    tag = finalAttrs.version;
    hash = "sha256-KfWjYDqJf2jNmYAnmV7EQHweMObEBreUc2G7/LpvvC0=";
  };

  postUnpack = lib.optional cavaSupport ''
    pushd "$sourceRoot"
    cp -R --no-preserve=mode,ownership ${libcava.src} subprojects/cava-0.10.4
    patchShebangs .
    popd
  '';

  patches = [
    (fetchpatch {
      name = "waybar-default-icon.patch";
      url = "https://github.com/Alexays/Waybar/commit/c336bc5466c858ac41dc9afd84f04a5ffec9e292.patch";
      hash = "sha256-RRGy/aeFX95fW0pT6mXhww2RdEtoOnaT3+dc7iB3bAY=";
    })
  ];

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      wayland-scanner
      wrapGAppsHook3
    ]
    ++ lib.optional withMediaPlayer gobject-introspection
    ++ lib.optional enableManpages scdoc;

  propagatedBuildInputs = lib.optionals withMediaPlayer [
    glib
    playerctl
    python3.pkgs.pygobject3
  ];

  buildInputs =
    [
      gtk-layer-shell
      gtkmm3
      jsoncpp
      libsigcxx
      libxkbcommon
      spdlog
      wayland
    ]
    ++ lib.optionals cavaSupport [
      SDL2
      alsa-lib
      fftw
      iniparser
      ncurses
      portaudio
    ]
    ++ lib.optional evdevSupport libevdev
    ++ lib.optional gpsSupport gpsd
    ++ lib.optional inputSupport libinput
    ++ lib.optional jackSupport libjack2
    ++ lib.optional mpdSupport libmpdclient
    ++ lib.optional mprisSupport playerctl
    ++ lib.optional nlSupport libnl
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional sndioSupport sndio
    ++ lib.optional systemdSupport systemdMinimal
    ++ lib.optional traySupport libdbusmenu-gtk3
    ++ lib.optional udevSupport udev
    ++ lib.optional upowerSupport upower
    ++ lib.optional wireplumberSupport wireplumber
    ++ lib.optional (cavaSupport || pipewireSupport) pipewire
    ++ lib.optional (!stdenv.hostPlatform.isLinux) libinotify-kqueue;

  nativeCheckInputs = [ catch2_3 ];
  doCheck = runTests;

  mesonFlags =
    (lib.mapAttrsToList lib.mesonEnable {
      "cava" = cavaSupport && lib.asserts.assertMsg sndioSupport "Sndio support is required for Cava";
      "dbusmenu-gtk" = traySupport;
      "gps" = gpsSupport;
      "jack" = jackSupport;
      "libevdev" = evdevSupport;
      "libinput" = inputSupport;
      "libnl" = nlSupport;
      "libudev" = udevSupport;
      "man-pages" = enableManpages;
      "mpd" = mpdSupport;
      "mpris" = mprisSupport;
      "pipewire" = pipewireSupport;
      "pulseaudio" = pulseSupport;
      "rfkill" = rfkillSupport;
      "sndio" = sndioSupport;
      "systemd" = systemdSupport;
      "tests" = runTests;
      "upower_glib" = upowerSupport;
      "wireplumber" = wireplumberSupport;
    })
    ++ (lib.mapAttrsToList lib.mesonBool {
      "experimental" = experimentalPatches;
      "niri" = niriSupport;
    });

  env = lib.optionalAttrs systemdSupport {
    PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";
  };

  postPatch = ''
    substituteInPlace include/util/command.hpp \
      --replace-fail /bin/sh ${lib.getExe' bash "sh"}
  '';

  preFixup = lib.optionalString withMediaPlayer ''
    cp $src/resources/custom_modules/mediaplayer.py $out/bin/waybar-mediaplayer.py

    wrapProgram $out/bin/waybar-mediaplayer.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3.sitePackages}"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/alexays/waybar";
    description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
    changelog = "https://github.com/alexays/waybar/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "waybar";
    maintainers = with lib.maintainers; [
      FlorianFranzen
      lovesegfault
      minijackson
      rodrgz
      synthetica
      khaneliman
    ];
    platforms = lib.platforms.linux;
  };
})
