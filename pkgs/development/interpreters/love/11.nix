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
  autoconf,
  automake,
  libtool,
  xorg,
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
    autoconf
    automake
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
    xorg.libX11 # SDL2 optional depend, for SDL_syswm.h
    libGLU
    libGL
  ];

  preConfigure = "$shell ./platform/unix/automagic";

  configureFlags = [
    (if stdenv.isDarwin then "--with-lua=lua" else "--with-lua=luajit")
  ];

  env.NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg"; # needed since luajit-2.1.0-beta3

  # Fix Darwin bundle/dylib linking and macOS function calls
  preBuild = lib.optionalString stdenv.isDarwin ''
    # Fix libtool to use dynamiclib instead of bundle for Darwin
    substituteInPlace libtool \
      --replace "-bundle" "-dynamiclib" \
      --replace "-Wl,-bundle" "-Wl,-dynamiclib"

    substituteInPlace src/love.cpp \
      --replace "love::macosx::checkDropEvents()" "std::string(\"\")" \
      --replace "love::macosx::getLoveInResources()" "std::string(\"\")"
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change ".libs/liblove-11.5.so" "$out/lib/liblove-11.5.so" "$out/bin/love"
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
