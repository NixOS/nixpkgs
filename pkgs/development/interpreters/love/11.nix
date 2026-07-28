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

stdenv.mkDerivation (finalAttrs: {
  pname = "love";
  version = "11.5";

  src = fetchFromGitHub {
    owner = "love2d";
    repo = "love";
    tag = finalAttrs.version;
    sha256 = "sha256-wZktNh4UB3QH2wAIIlnYUlNoXbjEDwUmPnT4vesZNm0=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    SDL2
    openal
    luajit
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
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11 # SDL2 optional depend, for SDL_syswm.h
    libGLU
    libGL
  ];

  # Use CMake instead of autotools on all platforms for uniformity
  # On Darwin, autotools doesn't compile macOS-specific module (src/common/macosx.mm),
  # leading to stubbed functions and segfaults
  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5") # Required by LÖVE's CMakeLists.txt
    (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true) # Don't include build directory in RPATH
    (lib.cmakeBool "CMAKE_BUILD_WITH_INSTALL_RPATH" true) # Use install RPATH even during build
    (lib.cmakeBool "LOVE_JIT" true) # Enable LuaJIT support even though it is warned about for Apple
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
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Install Linux-specific files (desktop, mime, icons)
    mkdir -p $out/share/applications
    mkdir -p $out/share/mime/packages
    mkdir -p $out/share/icons/hicolor/scalable/{apps,mimetypes}

    # Generate desktop file from template
    substitute $src/platform/unix/love.desktop.in $out/share/applications/love.desktop \
      --replace-fail '@bindir@' "$out/bin"

    cp $src/platform/unix/love.xml $out/share/mime/packages/
    cp $src/platform/unix/love.svg $out/share/icons/hicolor/scalable/apps
    cp $src/platform/unix/application-x-love-game.svg $out/share/icons/hicolor/scalable/mimetypes/
  ''
  + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
})
