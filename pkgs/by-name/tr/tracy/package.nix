{ lib
, stdenv
, fetchFromGitHub

, capstone
, darwin
, dbus
, freetype
, glfw
, hicolor-icon-theme
, pkg-config
, tbb

, withWayland ? stdenv.isLinux
, libxkbcommon
, wayland
}:

stdenv.mkDerivation rec {
  pname = "tracy";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "wolfpld";
    repo = "tracy";
    rev = "v${version}";
    sha256 = "sha256-DN1ExvQ5wcIUyhMAfiakFbZkDsx+5l8VMtYGvSdboPA=";
  };

  patches = lib.optionals (stdenv.isDarwin && !(lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11")) [
    ./0001-remove-unifiedtypeidentifiers-framework
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    capstone
    freetype
    glfw
  ] ++ lib.optionals (stdenv.isLinux && withWayland) [
    libxkbcommon
    wayland
  ] ++ lib.optionals stdenv.isLinux [
    dbus
    hicolor-icon-theme
    tbb
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.Carbon
  ] ++ lib.optionals (stdenv.isDarwin && lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") [
    darwin.apple_sdk.frameworks.UniformTypeIdentifiers
  ];

  env.NIX_CFLAGS_COMPILE = toString ([ ]
    # Apple's compiler finds a format string security error on
    # ../../../server/TracyView.cpp:649:34, preventing building.
    ++ lib.optional stdenv.isDarwin "-Wno-format-security"
    ++ lib.optional stdenv.isLinux "-ltbb"
    ++ lib.optional stdenv.cc.isClang "-faligned-allocation");

  buildPhase = ''
    runHook preBuild

    make -j $NIX_BUILD_CORES -C capture/build/unix release
    make -j $NIX_BUILD_CORES -C csvexport/build/unix release
    make -j $NIX_BUILD_CORES -C import-chrome/build/unix release
    make -j $NIX_BUILD_CORES -C library/unix release
    make -j $NIX_BUILD_CORES -C profiler/build/unix release \
      ${lib.optionalString (stdenv.isLinux && !withWayland) "LEGACY=1"}
    make -j $NIX_BUILD_CORES -C update/build/unix release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 0755 capture/build/unix/capture-release $out/bin/capture
    install -D -m 0755 csvexport/build/unix/csvexport-release $out/bin/tracy-csvexport
    install -D -m 0755 import-chrome/build/unix/import-chrome-release $out/bin/import-chrome
    install -D -m 0755 library/unix/libtracy-release.so $out/lib/libtracy.so
    install -D -m 0755 profiler/build/unix/Tracy-release $out/bin/tracy
    install -D -m 0755 update/build/unix/update-release $out/bin/update

    mkdir -p $out/include/Tracy/client
    mkdir -p $out/include/Tracy/common
    mkdir -p $out/include/Tracy/tracy

    cp -p public/client/*.{h,hpp} $out/include/Tracy/client
    cp -p public/common/*.{h,hpp} $out/include/Tracy/common
    cp -p public/tracy/*.{h,hpp} $out/include/Tracy/tracy
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace extra/desktop/tracy.desktop \
      --replace Exec=/usr/bin/tracy Exec=tracy

    install -D -m 0644 extra/desktop/application-tracy.xml $out/share/mime/packages/application-tracy.xml
    install -D -m 0644 extra/desktop/tracy.desktop $out/share/applications/tracy.desktop
    install -D -m 0644 icon/application-tracy.svg $out/share/icons/hicolor/scalable/apps/application-tracy.svg
    install -D -m 0644 icon/icon.png $out/share/icons/hicolor/256x256/apps/tracy.png
    install -D -m 0644 icon/icon.svg $out/share/icons/hicolor/scalable/apps/tracy.svg
  '' + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libcapstone.4.dylib ${capstone}/lib/libcapstone.4.dylib $out/bin/tracy
  '';

  meta = with lib; {
    description = "Real time, nanosecond resolution, remote telemetry frame profiler for games and other applications";
    homepage = "https://github.com/wolfpld/tracy";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.bsd3;
    mainProgram = "tracy";
    maintainers = with maintainers; [ mpickering nagisa paveloom ];
  };
}
