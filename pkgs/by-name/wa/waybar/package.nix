{
  lib,
  stdenv,
  bash,
  fetchFromGitHub,
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
  libdbusmenu-gtk3,
  libevdev,
  libinotify-kqueue,
  libinput,
  libjack2,
  libmpdclient,
  libnl,
  libpulseaudio,
  libsigcxx_2_0,
  libxkbcommon,
  meson,
  modemmanager,
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
  systemdLibs,
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
  mangoSupport ? true,
  mpdSupport ? true,
  mprisSupport ? stdenv.hostPlatform.isLinux,
  niriSupport ? true,
  nlSupport ? true,
  pipewireSupport ? true,
  pulseSupport ? true,
  rfkillSupport ? true,
  runTests ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  sndioSupport ? true,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
  traySupport ? true,
  udevSupport ? true,
  umbrielSupport ? true,
  upowerSupport ? true,
  wireplumberSupport ? true,
  wwanSupport ? true,
  withMediaPlayer ? mprisSupport && false,
  nix-update-script,
}:

let
  libcava =
    let
      # This comes from subprojects/libcava.wrap in the waybar sources
      version = "8d6e963db9cd29c2b3b5a5df1e46bb65c410f9cc";
    in
    {
      inherit version;

      src = fetchFromGitHub {
        owner = "LukashonakV";
        repo = "cava";
        rev = version;
        hash = "sha256-tWY3D3sEVFDHJjO/enCu0lEobM1CF4vupavOHgIslnA=";
      };
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "waybar";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    tag = finalAttrs.version;
    hash = "sha256-mHBaRnquV9tSt8FuaAU9/HG7B8gditQX6p3NgwiLmMY=";
  };

  postUnpack = lib.optionalString cavaSupport ''
    pushd "$sourceRoot"
    cp -R --no-preserve=mode,ownership ${libcava.src} subprojects/cava-${libcava.version}
    patchShebangs .
    popd
  '';

  nativeBuildInputs = [
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

  buildInputs = [
    gtk-layer-shell
    gtkmm3
    jsoncpp
    libsigcxx_2_0
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
  ++ lib.optional systemdSupport systemdLibs
  ++ lib.optional traySupport libdbusmenu-gtk3
  ++ lib.optional udevSupport udev
  ++ lib.optional upowerSupport upower
  ++ lib.optional wireplumberSupport wireplumber
  ++ lib.optional wwanSupport modemmanager
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
      "wwan" = wwanSupport;
    })
    ++ (lib.mapAttrsToList lib.mesonBool {
      "experimental" = experimentalPatches;
      "mango" = mangoSupport;
      "niri" = niriSupport;
      "umbriel" = umbrielSupport;
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
      khaneliman
    ];
    platforms = lib.platforms.linux;
  };
})
