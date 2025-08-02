{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
  ninja,
  python3,
  makeWrapper,

  backward-cpp,
  curl,
  enet,
  freetype,
  glm,
  gtest,
  libbfd,
  libdwarf,
  libjpeg,
  libuuid,
  libuv,
  libX11,
  lua5_4,
  lzfse,
  opencl-headers,
  SDL2,
  SDL2_mixer,
  wayland-protocols,

  callPackage,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vengi-tools";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "vengi-voxel";
    repo = "vengi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YSqMhwgCdJNf8sehwgPHhr/Nu6jKXCeszuRp3hPqz7g=";
  };

  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Disable code signing on macOS
    substituteInPlace cmake/macros.cmake --replace-fail "codesign" "true"
    substituteInPlace cmake/system/apple.cmake --replace-fail "if(APPLE)" "if(false)"

    # calls otool -L on /usr/lib/libSystem.B.dylib and fails because it doesn't exist
    substituteInPlace cmake/applebundle.cmake --replace-fail 'fixup_bundle("''${TARGET_BUNDLE_DIR}" "" "")' ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    python3
    makeWrapper
  ];

  buildInputs = [
    libbfd
    libdwarf
    backward-cpp
    curl
    enet
    freetype
    glm
    libjpeg
    libuuid
    libuv
    lua5_4
    lzfse
    SDL2
    libX11
    SDL2_mixer
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux wayland-protocols
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) opencl-headers;

  # error: "The plain signature for target_link_libraries has already been used"
  doCheck = false;

  checkInputs = [
    gtest
  ];

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        mv $out/*.app $out/Applications/

        mkdir -p $out/bin
        ln -s $out/Applications/vengi-voxconvert.app/Contents/MacOS/vengi-voxconvert $out/bin/vengi-voxconvert
      ''
    else
      # Set the data directory for each executable. We cannot set it at build time
      # with the PKGDATADIR cmake variable because each executable needs a specific
      # one.
      # This is not needed on darwin, since on that platform data files are saved
      # in *.app/Contents/Resources/ too, and are picked up automatically.
      ''
        for prog in $out/bin/*; do
          wrapProgram "$prog" \
            --set CORE_PATH $out/share/$(basename "$prog")/
        done
      '';

  passthru.tests = {
    voxconvert-roundtrip = callPackage ./test-voxconvert-roundtrip.nix { };
    voxconvert-all-formats = callPackage ./test-voxconvert-all-formats.nix { };
    run-voxedit = nixosTests.vengi-tools;
  };

  meta = with lib; {
    description = "Tools from the vengi voxel engine, including a thumbnailer, a converter, and the VoxEdit voxel editor";
    longDescription = ''
      Tools from the vengi C++ voxel game engine. It includes a voxel editor
      with character animation support and loading/saving into a lot of voxel
      volume formats. There are other tools like e.g. a thumbnailer for your
      filemanager and a command line tool to convert between several voxel
      formats.
    '';
    homepage = "https://vengi-voxel.github.io/vengi/";
    downloadPage = "https://github.com/vengi-voxel/vengi/releases";
    license = [
      licenses.mit
      licenses.cc-by-sa-30
    ];
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})
