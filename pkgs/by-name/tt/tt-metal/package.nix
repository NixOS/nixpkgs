{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  autoPatchelfHook,
  ncurses,
  isl_0_23,
  libmpc,
  mpfr,
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
  version = "0.59.1";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-iDO9q79gurIpIR+6swywlxTe3XI/2ToZxz11EuXc0gI=";
  };

  cpm = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.40.2/CPM.cmake";
    hash = "sha256-yM3DLAOBZTjOInge1ylk3IZLKjSjENO3EEgSpcotg10=";
  };

  sfpiVersion = "6.12.0";
  sfpiSource =
    {
      aarch64-linux = fetchurl {
        url = "https://github.com/tenstorrent/sfpi/releases/download/v${finalAttrs.sfpiVersion}/sfpi-aarch64_Linux.txz";
        hash = "sha256-4RGwYhsEGx1/ANBUmNeSQcdmMRjFXN8Bg3DICLF6d5o=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/tenstorrent/sfpi/releases/download/v${finalAttrs.sfpiVersion}/sfpi-x86_64_Linux.txz";
        hash = "sha256-hZvet4ErN1nNScjuU6YW7XEjvV9sR6xvb1IJjgMcXlg=";
      };
    }
    ."${stdenv.hostPlatform.system}" or (throw "SFPI does not support ${stdenv.hostPlatform.system}");

  postUnpack = ''
    mkdir -p "$sourceRoot/runtime"
    tar xf "$sfpiSource" -C "$sourceRoot/runtime"
    autoPatchelf \
      "$sourceRoot/runtime/sfpi/compiler/bin"/* \
      "$sourceRoot/runtime/sfpi/compiler/libexec/gcc/riscv32-tt-elf/12.4.0/cc1plus"\
      "$sourceRoot/runtime/sfpi/compiler/libexec/gcc/riscv32-tt-elf/12.4.0/cc1"
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

  preInstall = ''
    mkdir -p $out/include
    cp -r ../build/_deps/tt-logger-src/include/tt-logger $out/include/tt-logger
  '';

  postInstall = ''
    rm -rf $out/share/pkgconfig
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    ninja
    pkg-config
    python3
    ncurses
    isl_0_23
    mpfr
    libmpc
  ];

  buildInputs = [
    numactl
    boost
    mpi
    hwloc
  ];

  noAuditTmpdir = true;

  meta = {
    description = "TT-NN operator library, and TT-Metalium low level kernel programming model.";
    homepage = "https://tenstorrent.com";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
    platforms = lib.platforms.linux;
  };
})
