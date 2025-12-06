{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  runCommand,
  fetchurl,

  cmake,
  ninja,
  pkg-config,
  wayland-scanner,

  dbus,
  freetype,
  glfw,
  onetbb,

  withGtkFileSelector ? false,
  gtk3,

  withWayland ? stdenv.hostPlatform.isLinux,
  libglvnd,
  libxkbcommon,
  wayland,
  libffi,
}:

assert withGtkFileSelector -> stdenv.hostPlatform.isLinux;

let
  cpmSourceCache = import ./cpm-dependencies.nix {
    inherit
      lib
      fetchFromGitHub
      fetchurl
      fetchFromGitLab
      runCommand
      ;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = if withWayland then "tracy-wayland" else "tracy-glfw";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "wolfpld";
    repo = "tracy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-voHql8ETnrUMef14LYduKI+0LpdnCFsvpt8B6M/ZNmc=";
  };

  patches = [
    # CPM uses hashes in its cache directory, that include things like the absolute path to the `patch` command.
    # We cannot reasonably reconstruct that hash - therefore we simply replace all the hashes with "NIX_ORIGIN_HASH_STUB".
    ./cpm-no-hash.patch

    # CPM requires git to download the dependencies. We don't allow CPM to download the dependencies, and remove the git dependency
    ./no-git.patch
  ]
  ++
    lib.optionals
      (stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11")
      [
        ./dont-use-the-uniformtypeidentifiers-framework.patch
      ];

  postUnpack =
    # Copy the CPM source cache to a directory where cpm expects it
    ''
      mkdir -p $sourceRoot/cpm_source_cache
      cp -r --no-preserve=mode ${cpmSourceCache}/. $sourceRoot/cpm_source_cache
    ''
    # Darwin's sandbox requires explicit write permissions for CPM to manage the cache
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      chmod -R u+w $sourceRoot/cpm_source_cache
    ''
    # Manually apply the patches, that would have been applied to the downloaded source
    # We need to do that here, because in the cpmSourceCache we don't know about these patches yet
    + ''
      patch -d $sourceRoot/cpm_source_cache/imgui/NIX_ORIGIN_HASH_STUB/ -p1 < $sourceRoot/cmake/imgui-emscripten.patch
      patch -d $sourceRoot/cpm_source_cache/imgui/NIX_ORIGIN_HASH_STUB/ -p1 < $sourceRoot/cmake/imgui-loader.patch
      patch -d $sourceRoot/cpm_source_cache/ppqsort/NIX_ORIGIN_HASH_STUB/ -p1 < $sourceRoot/cmake/ppqsort-nodebug.patch
    '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wayland-scanner ]
  ++ lib.optionals stdenv.cc.isClang [ stdenv.cc.cc.libllvm ];

  buildInputs = [
    freetype
    libffi
    onetbb
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withGtkFileSelector) [ gtk3 ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && !withGtkFileSelector) [ dbus ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && withWayland) [
    libglvnd
    libxkbcommon
    wayland
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && !withWayland)) [
    glfw
  ];

  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_CAPSTONE" false)
    (lib.cmakeBool "TRACY_STATIC" false)
    (lib.cmakeFeature "CPM_SOURCE_CACHE" "/build/source/cpm_source_cache")
  ]
  ++ lib.optional (stdenv.hostPlatform.isLinux && withGtkFileSelector) "-DGTK_FILESELECTOR=ON"
  ++ lib.optional (stdenv.hostPlatform.isLinux && !withWayland) "-DLEGACY=on";

  env.NIX_CFLAGS_COMPILE = toString (
    [ ]
    ++ lib.optional stdenv.hostPlatform.isLinux "-ltbb"
    # Workaround for https://github.com/NixOS/nixpkgs/issues/19098
    ++ lib.optional (stdenv.cc.isClang && stdenv.hostPlatform.isDarwin) "-fno-lto"
  );

  dontUseCmakeBuildDir = true;

  postConfigure = ''
    cmake -B capture/build -S capture $cmakeFlags
    cmake -B csvexport/build -S csvexport $cmakeFlags
    cmake -B import/build -S import $cmakeFlags
    cmake -B profiler/build -S profiler $cmakeFlags
    cmake -B update/build -S update $cmakeFlags
  '';

  postBuild = ''
    ninja -C capture/build
    ninja -C csvexport/build
    ninja -C import/build
    ninja -C profiler/build
    ninja -C update/build
  '';

  postInstall = ''
    install -D -m 0555 capture/build/tracy-capture -t $out/bin
    install -D -m 0555 csvexport/build/tracy-csvexport $out/bin
    install -D -m 0555 import/build/{tracy-import-chrome,tracy-import-fuchsia} -t $out/bin
    install -D -m 0555 profiler/build/tracy-profiler $out/bin/tracy
    install -D -m 0555 update/build/tracy-update -t $out/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
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
    ];
    platforms = platforms.linux ++ lib.optionals (!withWayland) platforms.darwin;
  };
})
