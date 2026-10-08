{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  cmake,
  glib,
  libGL,
  libsndfile,
  libvpx,
  libwebp,
  libx11,
  makeWrapper,
  moltenvk,
  mpg123,
  ninja,
  openal,
  pkg-config,
  python3,
  sdl2-compat,
  vulkan-headers,
  vulkan-loader,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uzdoom";
  version = "5.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "UZDoom";
    repo = "UZDoom";
    tag = finalAttrs.version;
    hash = "sha256-iNPpkAV1ED+BRqa2WmB6R0PFaCqpmTWDCZT9USbmZuY=";
  };

  outputs = [ "out" ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "doc" ];

  postPatch = ''
    substituteInPlace cmake/UpdateRevision.cmake \
      --replace-fail "unknown" "${finalAttrs.src.tag}"
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    bzip2
    glib
    libGL
    libvpx
    libwebp
    openal
    sdl2-compat
    vulkan-loader
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    moltenvk
    vulkan-headers
  ];

  cmakeFlags = [
    (lib.cmakeBool "DYN_OPENAL" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "OPENAL_INCLUDE_DIR" "${openal}/include/AL")
    (lib.cmakeFeature "OPENAL_LIBRARY" "${openal}/lib/libopenal.dylib")
    (lib.cmakeFeature "Vulkan_INCLUDE_DIR" "${vulkan-headers}/include")
    (lib.cmakeFeature "Vulkan_MoltenVK_INCLUDE_DIR" "${lib.getDev moltenvk}/include")
    (lib.cmakeFeature "Vulkan_MoltenVK_LIBRARY" "${moltenvk}/lib/libMoltenVK.dylib")
    (lib.cmakeBool "HAVE_VULKAN" true)
    (lib.cmakeBool "HAVE_GLES2" false)
  ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p "$out"/{Applications,bin}
    mv uzdoom.app "$out/Applications/"
    makeWrapper $out/Applications/uzdoom.app/Contents/MacOS/uzdoom $out/bin/uzdoom \
      --chdir $out/Applications/uzdoom.app/Contents/MacOS/

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mv $out/bin/uzdoom $out/share/games/uzdoom/uzdoom
    makeWrapper $out/share/games/uzdoom/uzdoom $out/bin/uzdoom \
      --set LD_LIBRARY_PATH ${
        lib.makeLibraryPath [
          libsndfile
          mpg123
          vulkan-loader
        ]
      }
  '';

  meta = {
    description = "Modern, feature-rich source port for the classic game DOOM";
    longDescription = ''
      UZDoom is a feature centric port for all Doom engine games, based on
      GZDoom, adding an advanced renderer and powerful scripting capabilities
    '';
    homepage = "https://zdoom.org";
    changelog = "https://github.com/UZDoom/UZDoom/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      Gliczy
      keenanweaver
    ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "uzdoom";
  };
})
