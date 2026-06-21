{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  asciidoc,
  pkg-config,
  cmark,
  coeurl,
  curl,
  kdsingleapplication,
  libevent,
  libsecret,
  lmdb,
  lmdbxx,
  mtxclient,
  nlohmann_json,
  re2,
  spdlog,
  gst_all_1,
  libnice,
  qt5,
  withVoipSupport ? stdenv.hostPlatform.isLinux,
  rustPlatform,
  protobuf,
  buildPackages,
  sqlcipher
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "whisperfish";
  version = "0-unstable-2026-04-18";

  src = fetchFromGitLab {
    owner = "whisperfish";
    repo = "whisperfish";
    rev = "beba6a88e2ec7db1cfca4845365c478430e64e50";
    hash = "sha256-RWhTqT4uFNQddFWMpUjiBKwH9MA7mSyz9bTwUy5MkV8=";
  };

  cargoHash = "sha256-/wYMSxjry2f6UqBqfKKufFuaCV6/fxLrUigHYUEVXs0=";

  env.CXXFLAGS = "-std=c++17";

  preBuild = ''
    export PROTOC=${buildPackages.protobuf}/bin/protoc
  '';

  nativeBuildInputs = [
    asciidoc
    cmake
    lmdbxx
    pkg-config
    qt5.wrapQtAppsHook

    protobuf
  ];

  buildInputs = [
    cmark
    coeurl
    curl
    kdsingleapplication
    libevent
    libsecret
    lmdb
    mtxclient
    nlohmann_json
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtimageformats
    # qt5.qtkeychain
    qt5.qtmultimedia
    qt5.qtsvg
    qt5.qttools
    # qt5.qt-jdenticon
    re2
    spdlog

    protobuf
    sqlcipher
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt5.qtwayland
  ]
  ++ lib.optionals withVoipSupport [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { qt5Support = true; })
    gst_all_1.gst-plugins-bad
    libnice
  ];

  cmakeFlags = [
    (lib.cmakeBool "VOIP" withVoipSupport)
  ];

  preFixup = ''
    # unset QT_STYLE_OVERRIDE to avoid showing a blank window when started
    # https://github.com/NixOS/nixpkgs/issues/333009
    qtWrapperArgs+=(--unset QT_STYLE_OVERRIDE)
  ''
  + lib.optionalString withVoipSupport ''
    # add gstreamer plugins path to the wrapper
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    description = "Signal client originally for SailfishOS";
    homepage = "https://gitlab.com/whisperfish/whisperfish";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.onny ];
    platforms = lib.platforms.all;
    mainProgram = "whisperfish";
  };
})
