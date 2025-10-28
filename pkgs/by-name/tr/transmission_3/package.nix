{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  curl,
  libevent,
  inotify-tools,
  systemd,
  zlib,
  pcre,
  libb64,
  libutp,
  miniupnpc,
  dht,
  libnatpmp,
  libiconv,
  # Build options
  enableGTK3 ? false,
  gtk3,
  xorg,
  wrapGAppsHook3,
  enableQt ? false,
  qt5,
  nixosTests,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  enableDaemon ? true,
  enableCli ? true,
  installLib ? false,
  apparmorRulesFromClosure,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "transmission";
  version = "3.00";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    tag = finalAttrs.version;
    hash = "sha256-n4iEDt9AstDZPZXN47p13brNLbNWS3BTB+A4UuoEjzE=";
    fetchSubmodules = true;
  };

  patches = [
    # fix build with openssl 3.0
    ./transmission-3.00-openssl-3.patch
    # fix build with miniupnpc 2.2.8
    ./transmission-3.00-miniupnpc-2.2.8.patch
  ];

  # Compatibility with CMake < 3.5 has been removed from CMake.
  postPatch = ''
    substituteInPlace \
      CMakeLists.txt \
      --replace-fail \
        "cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)" \
        "cmake_minimum_required(VERSION 3.5)"
  '';

  outputs = [
    "out"
    "apparmor"
  ];

  cmakeFlags =
    let
      mkFlag = opt: if opt then "ON" else "OFF";
    in
    [
      "-DENABLE_MAC=OFF" # requires xcodebuild
      "-DENABLE_GTK=${mkFlag enableGTK3}"
      "-DENABLE_QT=${mkFlag enableQt}"
      "-DENABLE_DAEMON=${mkFlag enableDaemon}"
      "-DENABLE_CLI=${mkFlag enableCli}"
      "-DINSTALL_LIB=${mkFlag installLib}"
    ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ]
  ++ lib.optionals enableGTK3 [ wrapGAppsHook3 ]
  ++ lib.optionals enableQt [ qt5.wrapQtAppsHook ];

  buildInputs = [
    openssl
    curl
    libevent
    zlib
    pcre
    libb64
    libutp
    miniupnpc
    dht
    libnatpmp
  ]
  ++ lib.optionals enableQt [
    qt5.qttools
    qt5.qtbase
  ]
  ++ lib.optionals enableGTK3 [
    gtk3
    xorg.libpthreadstubs
  ]
  ++ lib.optionals enableSystemd [ systemd ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  postInstall = ''
    mkdir $apparmor
    cat >$apparmor/bin.transmission-daemon <<EOF
    include <tunables/global>
    $out/bin/transmission-daemon {
      include <abstractions/base>
      include <abstractions/nameservice>
      include <abstractions/ssl_certs>
      include "${
        apparmorRulesFromClosure { name = "transmission-daemon"; } (
          [
            curl
            libevent
            openssl
            pcre
            zlib
            libnatpmp
            miniupnpc
          ]
          ++ lib.optionals enableSystemd [ systemd ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ]
        )
      }"
      r @{PROC}/sys/kernel/random/uuid,
      r @{PROC}/sys/vm/overcommit_memory,
      r @{PROC}/@{pid}/environ,
      r @{PROC}/@{pid}/mounts,
      rwk /tmp/tr_session_id_*,

      r $out/share/transmission/web/**,

      include <local/bin.transmission-daemon>
    }
    EOF
  '';

  env = {
    # Fix GCC 14 build
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  passthru.tests = {
    apparmor = nixosTests.transmission_3; # starts the service with apparmor enabled
    smoke-test = nixosTests.bittorrent;
  };

  meta = {
    description = "Fast, easy and free BitTorrent client (deprecated version 3)";
    mainProgram =
      if enableQt then
        "transmission-qt"
      else if enableGTK3 then
        "transmission-gtk"
      else
        "transmission-cli";
    longDescription = ''
      Transmission is a BitTorrent client which features a simple interface
      on top of a cross-platform back-end.
      Feature spotlight:
        * Uses fewer resources than other clients
        * Native Mac, GTK and Qt GUI clients
        * Daemon ideal for servers, embedded systems, and headless use
        * All these can be remote controlled by Web and Terminal clients
        * Bluetack (PeerGuardian) blocklists with automatic updates
        * Full encryption, DHT, and PEX support
    '';
    homepage = "http://www.transmissionbt.com/";
    license = lib.licenses.gpl2Plus; # parts are under MIT
    platforms = lib.platforms.unix;
  };

})
