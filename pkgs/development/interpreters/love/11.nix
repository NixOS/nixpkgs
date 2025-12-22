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

  nativeBuildInputs =
    [ pkg-config ]
    ++ lib.optionals stdenv.isDarwin [ cmake ]
    ++ lib.optionals (!stdenv.isDarwin) [
      autoconf
      automake
    ];
  buildInputs =
    [
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

  preConfigure = lib.optionalString (!stdenv.isDarwin) "$shell ./platform/unix/automagic";

  configureFlags = [
    (if stdenv.isDarwin then "--with-lua=lua" else "--with-lua=luajit")
  ];

  # Use CMake on Darwin to build macOS-specific module (src/common/macosx.mm)
  # Autotools build doesn't compile this file, leading to stubbed functions and segfaults
  configurePhase = lib.optionalString stdenv.isDarwin ''
    mkdir -p build
    cd build
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
  '';

  env.NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg"; # needed since luajit-2.1.0-beta3

  # CMake doesn't define install target for LÖVE, so install manually on Darwin
  installPhase = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/bin $out/lib
    cp love $out/bin/
    cp libliblove.dylib $out/lib/
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
