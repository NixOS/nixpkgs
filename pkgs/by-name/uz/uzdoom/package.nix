{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  cmake,
  gtk3,
  libGL,
  libvpx,
  libwebp,
  makeWrapper,
  ninja,
  openal,
  pkg-config,
  SDL2,
  vulkan-loader,
  zlib,
  zmusic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uzdoom";
  version = "4.14.3";

  src = fetchFromGitHub {
    owner = "UZDoom";
    repo = "UZDoom";
    tag = finalAttrs.version;
    hash = "sha256-vMynousxc2k7jSa6ScYNeZ9/ozRnDXTyKwgcYQcf87M=";
  };

  outputs = [ "out" ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "doc" ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
  ];

  buildInputs = [
    bzip2
    gtk3
    libGL
    libvpx
    libwebp
    openal
    SDL2
    vulkan-loader
    zlib
    zmusic
  ];

  postPatch = ''
    substituteInPlace tools/updaterevision/UpdateRevision.cmake \
      --replace-fail "unknown" "${finalAttrs.src.tag}"
  '';

  cmakeFlags = [
    (lib.cmakeBool "DYN_GTK" false)
    (lib.cmakeBool "DYN_OPENAL" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "OPENAL_INCLUDE_DIR" "${openal}/include/AL")
    (lib.cmakeFeature "OPENAL_LIBRARY" "${openal}/lib/libopenal.dylib")
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
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = {
    homepage = "https://github.com/UZDoom/UZDoom";
    description = "Modder-friendly OpenGL and Vulkan source port based on the DOOM engine";
    mainProgram = "uzdoom";
    longDescription = ''
      UZDoom is a feature centric port for all Doom engine games, based on
      GZDoom, adding an advanced renderer and powerful scripting capabilities
    '';
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      Gliczy
      keenanweaver
    ];
  };
})
