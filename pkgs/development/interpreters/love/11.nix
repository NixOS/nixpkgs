{
  SDL2,
  cmake,
  fetchFromGitHub,
  lib,
  libjpeg,
  libmodplug,
  libogg,
  libpng,
  libtheora,
  libvorbis,
  libwebp,
  lua5_1,
  luajit,
  mesa,
  mpg123,
  openal,
  physfs,
  pkg-config,
  stdenv,
  xorg,
  zlib,
  freetype,
}:

stdenv.mkDerivation rec {
  pname = "love";
  version = "11.5";

  src = fetchFromGitHub {
    owner = "love2d";
    repo = "love";
    rev = version;
    hash = "sha256-sem36AKK79EC2oeV/RS5ikWxU8P93clz0xtK1PKwkME=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    freetype
    libjpeg
    libmodplug
    libogg
    libpng
    libtheora
    libvorbis
    libwebp
    lua5_1
    mpg123
    openal
    physfs
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    mesa
    xorg.libX11
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DLIBLOVE_USE_SYSTEM_ZLIB=ON"
    "-DLIBLOVE_USE_SYSTEM_LIBPNG=ON"
    "-DLIBLOVE_USE_SYSTEM_LIBJPEG=ON"
    "-DLIBLOVE_USE_SYSTEM_WEBP=ON"
    "-DLIBLOVE_USE_SYSTEM_FREETYPE=ON"
    "-DLIBLOVE_USE_SYSTEM_PHYSFS=ON"
    "-DLIBLOVE_USE_SYSTEM_OPENAL=ON"
    "-DLIBLOVE_USE_SYSTEM_SDL2=ON"
    "-DLIBLOVE_USE_SYSTEM_OGG=ON"
    "-DLIBLOVE_USE_SYSTEM_VORBIS=ON"
    "-DLIBLOVE_USE_SYSTEM_THEORA=ON"
    "-DLIBLOVE_USE_SYSTEM_MODPLUG=ON"
    "-DLIBLOVE_USE_SYSTEM_MPG123=ON"
    # Lua 5.1 (Darwin lib name differs from Linux)
    "-DLUA_INCLUDE_DIR=${lua5_1.out}/include"
    "-DLUA_LIBRARIES=${
      if stdenv.hostPlatform.isDarwin then
        "${lua5_1.out}/lib/liblua.5.1.dylib"
      else
        "${lua5_1.out}/lib/liblua5.1.so"
    }"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13"
    # Make the installed binary find @rpath/*.dylib in $out/lib
    "-DCMAKE_MACOSX_RPATH=ON"
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DCMAKE_INSTALL_RPATH=@loader_path/../lib"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DCMAKE_INSTALL_RPATH=\$ORIGIN/../lib"
  ];

  # Ensure common macOS frameworks are linked.
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo";

  # Upstream lacks install rules; install manually from the build dir.
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/lib"
    # binary
    install -m755 love "$out/bin/love"
    # shared lib: keep the exact filename the binary links against
    if [ -f libliblove.dylib ]; then
      install -m755 libliblove.dylib "$out/lib/"
    elif [ -f liblove.dylib ]; then
      # fallback: also provide the name the binary expects
      install -m755 liblove.dylib "$out/lib/"
      ln -s liblove.dylib "$out/lib/libliblove.dylib"
    fi
    runHook postInstall
  '';

  # On Darwin, make sure install_name IDs and rpaths are sane at runtime.
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Give the dylib an @rpath id so dependents resolve it via the binary's rpath
    if [ -f "$out/lib/libliblove.dylib" ]; then
      install_name_tool -id "@rpath/libliblove.dylib" "$out/lib/libliblove.dylib" || true
    fi
    # Ensure the executable has an rpath to ../lib (redundant with CMake flags but safe)
    install_name_tool -add_rpath "@loader_path/../lib" "$out/bin/love" || true
  '';

  meta = {
    description = "Framework for making 2D games in Lua";
    homepage = "https://love2d.org/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    mainProgram = "love";
    maintainers = with lib.maintainers; [
      raskin
      dannydannydanny
    ];
  };
}
