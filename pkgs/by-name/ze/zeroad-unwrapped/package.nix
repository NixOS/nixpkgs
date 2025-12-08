{
  stdenv,
  lib,
  perl,
  fetchurl,
  python3,
  fmt,
  libidn,
  pkg-config,
  spidermonkey_115,
  boost,
  icu,
  libxml2,
  libpng,
  libsodium,
  libjpeg,
  zlib,
  curl,
  libogg,
  libvorbis,
  enet,
  miniupnpc,
  openal,
  libGLU,
  libGL,
  xorgproto,
  libX11,
  libXcursor,
  nspr,
  SDL2,
  gloox,
  nvidia-texture-tools,
  premake5,
  cxxtest,
  freetype,
  withEditor ? true,
  wxGTK,
}:

# You can find more instructions on how to build 0ad here:
#    https://trac.wildfiregames.com/wiki/BuildInstructions

stdenv.mkDerivation rec {
  pname = "0ad";
  version = "0.27.1";

  src = fetchurl {
    url = "https://releases.wildfiregames.com/0ad-${version}-unix-build.tar.xz";
    hash = "sha256-oKU1XutZaNJPKDdwc2FQ2XTa/sugd1TUZicH3BcBa/s=";
  };

  nativeBuildInputs = [
    python3
    perl
    pkg-config
  ];

  buildInputs = [
    spidermonkey_115
    boost
    icu
    libxml2
    libpng
    libjpeg
    zlib
    curl
    libogg
    libvorbis
    enet
    miniupnpc
    openal
    libidn
    libGLU
    libGL
    xorgproto
    libX11
    libXcursor
    nspr
    SDL2
    gloox
    nvidia-texture-tools
    libsodium
    fmt
    freetype
    premake5
    cxxtest
  ]
  ++ lib.optional withEditor wxGTK;

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${xorgproto}/include"
    "-I${libX11.dev}/include"
    "-I${libXcursor.dev}/include"
    "-I${SDL2}/include/SDL2"
    "-I${fmt.dev}/include"
    "-I${nvidia-texture-tools.dev}/include"
  ];

  NIX_CFLAGS_LINK = toString [
    "-L${nvidia-texture-tools.lib}/lib/static"
  ];

  patches = [
    ./rootdir_env.patch
  ];

  configurePhase = ''
    runHook preConfigure

    # Delete shipped libraries which we don't need.
    rm -rf libraries/source/{cxxtest-4.4,nvtt,premake-core,spidermonkey,spirv-reflect}

    # Build remaining library dependencies (should be fcollada only)
    pushd libraries
    ./build-source-libs.sh \
      --with-system-cxxtest \
      --with-system-nvtt \
      --with-system-mozjs \
      --with-system-premake \
      -j$NIX_BUILD_CORES
    popd

    # Update Makefiles
    pushd build/workspaces
    ./update-workspaces.sh \
      --with-system-premake5 \
      --with-system-cxxtest \
      --with-system-nvtt \
      --with-system-mozjs \
      ${lib.optionalString (!withEditor) "--without-atlas"} \
      --bindir="$out"/bin \
      --libdir="$out"/lib/0ad \
      --without-tests \
      -j $NIX_BUILD_CORES
    popd

    # Move to the build directory.
    pushd build/workspaces/gcc

    runHook postConfigure
  '';

  enableParallelBuilding = true;

  installPhase = ''
    popd

    # Copy executables.
    install -Dm755 binaries/system/pyrogenesis "$out"/bin/0ad
    ${lib.optionalString withEditor ''
      install -Dm755 binaries/system/ActorEditor "$out"/bin/ActorEditor
    ''}

    # Copy l10n data.
    install -Dm755 -t $out/share/0ad/data/l10n binaries/data/l10n/*

    # Copy libraries.
    install -Dm644 -t $out/lib/0ad        binaries/system/*.so

    # Copy icon.
    install -D build/resources/0ad.png     $out/share/icons/hicolor/128x128/apps/0ad.png
    install -D build/resources/0ad.desktop $out/share/applications/0ad.desktop
  '';

  meta = with lib; {
    description = "Free, open-source game of ancient warfare";
    homepage = "https://play0ad.com/";
    license = with licenses; [
      gpl2Plus
      lgpl21
      mit
      cc-by-sa-30
      licenses.zlib # otherwise masked by pkgs.zlib
    ];
    maintainers = with maintainers; [ chvp ];
    platforms = subtractLists platforms.i686 platforms.linux;
    mainProgram = "0ad";
  };
}
