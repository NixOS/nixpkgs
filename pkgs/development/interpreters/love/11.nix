{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  SDL2,
  libGLU,
  libGL,
  openal,
  luajit,
  lua5_1,
  freetype,
  physfs,
  libmodplug,
  mpg123,
  libvorbis,
  libogg,
  libtheora,
  which,
  libtool,
  libx11,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "love";
  version = "11.5";

  src = fetchFromGitHub {
    owner = "love2d";
    repo = "love";
    rev = version;
    sha256 = "sha256-wZktNh4UB3QH2wAIIlnYUlNoXbjEDwUmPnT4vesZNm0=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    SDL2
    openal
    (if stdenv.isDarwin then lua5_1 else luajit)
    freetype
    physfs
    libmodplug
    mpg123
    libvorbis
    libogg
    libtheora
    which
    libtool
  ]
  ++ lib.optionals stdenv.isLinux [
    libx11 # SDL2 optional depend, for SDL_syswm.h
    libGLU
    libGL
  ];

  # Use CMake instead of autotools on all platforms for uniformity
  # On Darwin, autotools doesn't compile macOS-specific module (src/common/macosx.mm),
  # leading to stubbed functions and segfaults
  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" # Required by LÖVE's CMakeLists.txt
    "-DCMAKE_SKIP_BUILD_RPATH=ON" # Don't include build directory in RPATH
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON" # Use install RPATH even during build
  ];

  env.NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg"; # needed since luajit-2.1.0-beta3

  # CMake doesn't define install target for LÖVE, so install manually
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib
    cp love $out/bin/
    cp libliblove.* $out/lib/

    # Install man page (both Linux and Darwin)
    mkdir -p $out/share/man/man1
    cp $src/platform/unix/love.6 $out/share/man/man1/love.1
    gzip -9n $out/share/man/man1/love.1
  ''
  + lib.optionalString stdenv.isLinux ''
    # Install Linux-specific files (desktop, mime, icons)
    mkdir -p $out/share/applications
    mkdir -p $out/share/mime/packages
    mkdir -p $out/share/pixmaps
    mkdir -p $out/share/icons/hicolor/scalable/mimetypes

    # Generate desktop file from template
    substitute $src/platform/unix/love.desktop.in $out/share/applications/love.desktop \
      --replace-fail '@bindir@' "$out/bin"

    cp $src/platform/unix/love.xml $out/share/mime/packages/
    cp $src/platform/unix/love.svg $out/share/pixmaps/
    cp $src/platform/unix/application-x-love-game.svg $out/share/icons/hicolor/scalable/mimetypes/
  ''
  + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    # Fix rpath so love binary can find libliblove.dylib
    install_name_tool -change "@rpath/libliblove.dylib" "$out/lib/libliblove.dylib" "$out/bin/love"
  '';

  meta = {
    homepage = "https://love2d.org";
    description = "Lua-based 2D game engine/scripting language";
    mainProgram = "love";
    license = lib.licenses.zlib;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.raskin ];
  };
}
