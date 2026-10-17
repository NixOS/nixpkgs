{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  applyPatches,
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
  version = "0.79.0";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "tt-metal";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-sA9ryiVDBF9yJUfQ2cQDvphEC0nVQx6X2F91s2BA8Qo=";
  };

  cpm = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.40.2/CPM.cmake";
    hash = "sha256-yM3DLAOBZTjOInge1ylk3IZLKjSjENO3EEgSpcotg10=";
  };

  sfpi = callPackage ./sfpi.nix { };

  patches = [
    # Remove in next release 0.80.0
    ./spsc-marker-decode-simde.patch
  ];

  postUnpack = ''
    mkdir -p "$sourceRoot/runtime"
    ln -s "$sfpi" "$sourceRoot/runtime/sfpi"
  '';

  postPatch = ''
    cp $cpm cmake/CPM.cmake
    cp $cpm tt_metal/third_party/umd/cmake/CPM.cmake

    patchShebangs tt_metal/sfpi-info.sh tt_metal/llrt/hal/codegen
    substituteInPlace tt_metal/sfpi-info.sh \
      --replace-fail 'sfpi_arch=$(uname -m)' $'sfpi_dist=debian\nsfpi_arch=$(uname -m)'
  '';

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "CPM_USE_LOCAL_PACKAGES" true)
    (lib.cmakeFeature "VERSION_NUMERIC" finalAttrs.version)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
    (lib.cmakeBool "ENABLE_TRACY" false)
  ];

  preConfigure = ''
    mkdir -p build/_deps
    ${lib.concatMapAttrsStringSep "\n"
      (name: src: "cp -r --no-preserve=ownership,mode ${src} build/_deps/${name}-src")
      (
        import ./deps.nix {
          inherit fetchFromGitHub applyPatches;
          ttMetalSrc = finalAttrs.src;
        }
      )
    }
    cp $cpm build/_deps/tt-logger-src/cmake/CPM.cmake

    appendToVar cmakeFlags "-Dcadical_SOURCE_DIR=$PWD/build/_deps/cadical-src"
    appendToVar cmakeFlags "-DCPM_umd_asio_SOURCE=$PWD/build/_deps/umd_asio-src"
    appendToVar cmakeFlags "-DCPM_ELFIO_SOURCE=$PWD/build/_deps/elfio-src"
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

  passthru.sfpi = finalAttrs.sfpi;

  meta = {
    description = "TT-NN operator library, and TT-Metalium low level kernel programming model";
    homepage = "https://github.com/tenstorrent/tt-metal";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
})
