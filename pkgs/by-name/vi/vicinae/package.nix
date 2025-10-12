{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  rapidfuzz-cpp,
  protobuf,
  grpc-tools,
  nodejs,
  minizip-ng,
  cmark-gfm,
  libqalculate,
  ninja,
  lib,
  fetchNpmDeps,
  protoc-gen-js,
  rsync,
  which,
  autoPatchelfHook,
  writeShellScriptBin,
  minizip,
  qt6,
  typescript,
  wayland,
}:
let
  _src = fetchFromGitHub {
    owner = "vicinaehq";
    repo = "vicinae";
    tag = "v0.14.5";
    hash = "sha256-yO2gMpx1mnSJrGooXWpVcSlK3XVL9Empr4uaR6OnlSI=";
  };
  apiDeps = fetchNpmDeps {
    src = "${_src}/typescript/api";
    hash = "sha256-dSHEzw15lSRRbldl9PljuWFf2htdG+HgSeKPAB88RBg=";
  };
  ts-protoc-gen-wrapper = writeShellScriptBin "protoc-gen-ts_proto" ''
    exec node /build/source/vicinae-upstream/typescript/api/node_modules/.bin/protoc-gen-ts_proto
  '';
  extensionManagerDeps = fetchNpmDeps {
    src = "${_src}/typescript/extension-manager";
    hash = "sha256-TCT7uZRZn4rsLA/z2yLeK5Bt4DJPmdSC4zkmuCxTtc8=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vicinae";
  version = "0.14.5";

  src = _src;

  cmakeFlags = [
    "-DVICINAE_PROVENANCE=nix"
    "-DINSTALL_NODE_MODULES=OFF"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_DATAROOTDIR=share"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  nativeBuildInputs = [
    ts-protoc-gen-wrapper
    extensionManagerDeps
    autoPatchelfHook
    cmake
    ninja
    nodejs
    pkg-config
    qt6.wrapQtAppsHook
    rapidfuzz-cpp
    protoc-gen-js
    protobuf
    grpc-tools
    which
    rsync
    typescript
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6.qtwayland
    qt6.qtdeclarative
    qt6.qt5compat
    wayland
    kdePackages.qtkeychain
    kdePackages.layer-shell-qt
    minizip
    grpc-tools
    protobuf
    nodejs
    minizip-ng
    cmark-gfm
    libqalculate
  ];
  configurePhase = ''
    cmake -G Ninja -B build $cmakeFlags
  '';

  buildPhase = ''
    buildDir=$PWD
    echo $buildDir
    export npm_config_cache=${apiDeps}
    cd $buildDir/typescript/api
    npm i --ignore-scripts
    patchShebangs $buildDir/typescript/api
    npm rebuild --foreground-scripts
    export npm_config_cache=${extensionManagerDeps}
    cd $buildDir/typescript/extension-manager
    npm i --ignore-scripts
    patchShebangs $buildDir/typescript/extension-manager
    npm rebuild --foreground-scripts
    cd $buildDir
    cmake --build build
    cd $buildDir
  '';

  dontWrapQtApps = true;
  # preFixup = ''
  #   wrapQtApp "$out/bin/vicinae" --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
  # '';
  postFixup = ''
    wrapProgram $out/bin/vicinae \
    --prefix PATH : ${
      lib.makeBinPath [
        nodejs
        qt6.qtwayland
        wayland
        (placeholder "out")
      ]
    }
  '';

  installPhase = ''
    cmake --install build
  '';

  meta = with lib; {
    description = "A focused launcher for your desktop — native, fast, extensible";
    homepage = "https://github.com/vicinaehq/vicinae";
    license = licenses.gpl3Plus;
    mainProgram = "vicinae";
    maintainers = with maintainers; [ zstg ];
    platforms = platforms.linux;
  };
  passthru = {
    inherit apiDeps extensionManagerDeps;
  };
})
