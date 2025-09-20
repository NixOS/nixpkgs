{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  callPackage,
  pkg-config,
  cmake,
  ninja,
  boost,
  numactl,
  mpi,
  hwloc,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tt-metal";
  version = "0.62.2";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-metal";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ZIUjZLifRVmpWpG8Ty+I+pwgpIf5r9gJkI8ULTau4OE=";
  };

  cpm = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.40.2/CPM.cmake";
    hash = "sha256-yM3DLAOBZTjOInge1ylk3IZLKjSjENO3EEgSpcotg10=";
  };

  sfpi = callPackage ./sfpi.nix { };

  postUnpack = ''
    mkdir -p "$sourceRoot/runtime"
    ln -s "$sfpi" "$sourceRoot/runtime/sfpi"
  '';

  postPatch = ''
    cp $cpm cmake/CPM.cmake
    cp $cpm tt_metal/third_party/umd/cmake/CPM.cmake
  '';

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "CPM_USE_LOCAL_PACKAGES" true)
    (lib.cmakeFeature "VERSION_NUMERIC" finalAttrs.version)
  ];

  preConfigure = ''
    mkdir -p build/_deps
    ${lib.concatMapAttrsStringSep "\n"
      (name: src: "cp -r --no-preserve=ownership,mode ${src} build/_deps/${name}-src")
      (
        import ./deps.nix {
          inherit fetchFromGitHub;
        }
      )
    }
    cp $cpm build/_deps/tt-logger-src/cmake/CPM.cmake
  '';

  # CMake install fails because "$out/include/tt-logger" tree does not exist.
  preInstall = ''
    mkdir -p $out/include
    cp -r ../build/_deps/tt-logger-src/include/tt-logger $out/include/tt-logger
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    numactl
    boost
    mpi
    hwloc
  ];

  # Fixes the parallel hook crashing in the fixupPhase with no error.
  noAuditTmpdir = true;

  meta = {
    description = "TT-NN operator library, and TT-Metalium low level kernel programming model";
    homepage = "https://github.com/tenstorrent/tt-metal";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
    platforms = lib.platforms.linux;
  };
})
