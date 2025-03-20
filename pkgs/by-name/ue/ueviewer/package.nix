{
  gccStdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  unstableGitUpdater,
  libpng,
  perl,
  SDL2,
  zlib,
}:

gccStdenv.mkDerivation (finalAttrs: {
  pname = "ueviewer";
  version = "0-unstable-2024-02-23";

  src = fetchFromGitHub {
    owner = "gildor2";
    repo = "UEViewer";
    rev = "a0bfb468d42be831b126632fd8a0ae6b3614f981";
    hash = "sha256-Cz4jK2jJMzz57/RcEzjIjD611vCy7l3xQ0pQZjneTFQ=";
  };

  patches = [
    # Fix compilation on Darwin
    # Remove when https://github.com/gildor2/UEViewer/pull/319 merged
    (fetchpatch {
      name = "0001-ueviewer-Dont-use-c++2a-standard.patch";
      url = "https://github.com/gildor2/UEViewer/commit/d44bef038abca99c84d7f418aedcbcb761de58aa.patch";
      hash = "sha256-v68yoBLz0dUB3evlKApKuajKQiOwbJczVeW5oxYaVyw=";
    })
  ];

  postPatch = ''
    patchShebangs build.sh Unreal/Shaders/make.pl Tools/genmake

    # Enable more verbose build output
    # Unify -j arguments on make calls
    # Show what's being run
    substituteInPlace build.sh \
      --replace-fail '#	echo ">> Debug: $*"' '	echo ">> Debug: $*"' \
      --replace-fail 'make -j 4 -f $makefile' 'make -f $makefile' \
      --replace-fail 'make -f $makefile' "make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}} -f \$makefile SHELL='sh -x'"

    # - Use correct compiler from stdenv
    # - Use C++ compiler instead of relying on leniency
    # -pipe breaks GCC on Darwin: clang-16: error: no input files
    substituteInPlace Tools/genmake \
      --replace-fail 'my $platf = "gcc";' "my \$platf = \"$CXX\";" \
      --replace-fail '-pipe' ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    perl
  ];

  buildInputs =
    [
      libpng
      zlib
    ]
    ++ lib.optionals (!gccStdenv.hostPlatform.isDarwin) [
      SDL2
    ];

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild

    ./build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 umodel $out/bin/umodel

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    # Tags represent various milestones, nothing that can be mapped to a numerical version number
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    description = "Viewer and exporter for Unreal Engine 1-4 assets (aka umodel)";
    homepage = "https://www.gildor.org/en/projects/umodel";
    license = licenses.mit;
    mainProgram = "umodel";
    maintainers = with maintainers; [ OPNA2608 ];
    # Hardcoded usage of SSE2
    platforms = platforms.x86;
  };
})
