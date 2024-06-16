{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  ninja,

  capstone,
  darwin,
  dbus,
  freetype,
  glfw,
  pkg-config,
  tbb,

  withGtkFileSelector ? false,
  gtk3,

  withWayland ? stdenv.isLinux,
  libglvnd,
  libxkbcommon,
  wayland-protocols,
  wayland,
}:

assert withGtkFileSelector -> stdenv.isLinux;
assert withWayland -> stdenv.isLinux;

stdenv.mkDerivation rec {
  pname = if withWayland then "tracy-wayland" else "tracy-glfw";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "wolfpld";
    repo = "tracy";
    rev = "v${version}";
    sha256 = "sha256-wGKnmCpmG70Xx/+RfZhXTLSY38AcGrZK/jxPpePkXik=";
  };

  patches = lib.optional (
    stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11"
  ) ./dont-use-the-uniformtypeidentifiers-framework.patch;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ] ++ lib.optionals stdenv.cc.isClang [ stdenv.cc.cc.libllvm ];

  buildInputs =
    [
      capstone
      freetype
      tbb
    ]
    ++ lib.optionals (stdenv.isLinux && withGtkFileSelector) [ gtk3 ]
    ++ lib.optionals (stdenv.isLinux && !withGtkFileSelector) [ dbus ]
    ++ lib.optionals (stdenv.isLinux && withWayland) [
      libglvnd
      libxkbcommon
      wayland
      wayland-protocols
    ]
    ++ lib.optionals (stdenv.isDarwin || (stdenv.isLinux && !withWayland)) [ glfw ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ]
    ++ lib.optionals (stdenv.isDarwin && lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") [
      darwin.apple_sdk.frameworks.UniformTypeIdentifiers
    ];

  cmakeFlags =
    [
      "-DDOWNLOAD_CAPSTONE=off"
      "-DTRACY_STATIC=off"
    ]
    ++ lib.optional (stdenv.isLinux && withGtkFileSelector) "-DGTK_FILESELECTOR=ON"
    ++ lib.optional (stdenv.isLinux && !withWayland) "-DLEGACY=on";

  env.NIX_CFLAGS_COMPILE = toString (
    [ ]
    ++ lib.optional stdenv.isLinux "-ltbb"
    ++ lib.optional (
      stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "10.13"
    ) "-fno-aligned-allocation"
    # Workaround for https://github.com/NixOS/nixpkgs/issues/19098
    ++ lib.optional (stdenv.cc.isClang && stdenv.isDarwin) "-fno-lto"
  );

  dontUseCmakeBuildDir = true;

  postConfigure = ''
    cmake -B capture/build -S capture $cmakeFlags
    cmake -B csvexport/build -S csvexport $cmakeFlags
    cmake -B import-chrome/build -S import-chrome $cmakeFlags
    cmake -B import-fuchsia/build -S import-fuchsia $cmakeFlags
    cmake -B profiler/build -S profiler $cmakeFlags
    cmake -B update/build -S update $cmakeFlags
  '';

  postBuild = ''
    ninja -C capture/build
    ninja -C csvexport/build
    ninja -C import-chrome/build
    ninja -C import-fuchsia/build
    ninja -C profiler/build
    ninja -C update/build
  '';

  postInstall =
    ''
      install -D -m 0555 capture/build/tracy-capture -t $out/bin
      install -D -m 0555 csvexport/build/tracy-csvexport $out/bin
      install -D -m 0555 import-chrome/build/tracy-import-chrome -t $out/bin
      install -D -m 0555 import-fuchsia/build/tracy-import-fuchsia -t $out/bin
      install -D -m 0555 profiler/build/tracy-profiler $out/bin/tracy
      install -D -m 0555 update/build/tracy-update -t $out/bin
    ''
    + lib.optionalString stdenv.isLinux ''
      substituteInPlace extra/desktop/tracy.desktop \
        --replace-fail Exec=/usr/bin/tracy Exec=tracy

      install -D -m 0444 extra/desktop/application-tracy.xml $out/share/mime/packages/application-tracy.xml
      install -D -m 0444 extra/desktop/tracy.desktop $out/share/applications/tracy.desktop
      install -D -m 0444 icon/application-tracy.svg $out/share/icons/hicolor/scalable/apps/application-tracy.svg
      install -D -m 0444 icon/icon.png $out/share/icons/hicolor/256x256/apps/tracy.png
      install -D -m 0444 icon/icon.svg $out/share/icons/hicolor/scalable/apps/tracy.svg
    '';

  meta = with lib; {
    description = "Real time, nanosecond resolution, remote telemetry frame profiler for games and other applications";
    homepage = "https://github.com/wolfpld/tracy";
    license = licenses.bsd3;
    mainProgram = "tracy";
    maintainers = with maintainers; [
      mpickering
      nagisa
      paveloom
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
