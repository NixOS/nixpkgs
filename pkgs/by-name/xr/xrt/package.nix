{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  cmake,
  pkg-config,
  gitMinimal,
  curl,
  boost,
  libdrm,
  systemd,
  ocl-icd,
  opencl-headers,
  libuuid,
  libxml2,
  ncurses,
  yaml-cpp,
  openssl,
  rapidjson,
  protobuf,
  libsystemtap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrt";
  version = "2.21.75";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Xilinx";
    repo = "XRT";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-sujiSRZuIelhvUew7yeCfApAmp/Pf2+F38KO9cxI2HE=";
  };

  postPatch =
    # Disable static aiebu utilities which require static glibc
    ''
      substituteInPlace src/runtime_src/core/common/aiebu/src/cpp/utils/CMakeLists.txt \
        --replace-fail "add_subdirectory(asm)" "" \
        --replace-fail "add_subdirectory(dump)" ""
    ''
    # Disable aiebu tests that reference the disabled utilities
    + ''
      substituteInPlace src/runtime_src/core/common/aiebu/CMakeLists.txt \
        --replace-fail "add_subdirectory(test)" ""
    ''
    # The emulation flow (which provides the `xrt_hwemu` target) is only built on x86_64, but the
    # XDP hw-emulation profiling plugins depend on `xrt_hwemu` unconditionally on Linux, breaking
    # CMake configuration on other platforms.
    # Drop them, mirroring the emulation gating in core/pcie/CMakeLists.txt.
    + lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
      substituteInPlace src/runtime_src/xdp/profile/plugin/CMakeLists.txt \
        --replace-fail \
          "add_subdirectory(device_offload/hw_emu)" \
          ""

      substituteInPlace src/runtime_src/xdp/profile/plugin/pl_deadlock/CMakeLists.txt \
        --replace-fail \
          "if (NOT WIN32)" \
          'if (NOT WIN32 AND ''${CMAKE_SYSTEM_PROCESSOR} STREQUAL "x86_64")'
    '';

  nativeBuildInputs = [
    cmake
    pkg-config
    gitMinimal
  ];

  buildInputs = [
    boost
    curl
    libdrm
    systemd
    ocl-icd
    opencl-headers
    libuuid
    libxml2
    ncurses
    yaml-cpp
    openssl
    rapidjson
    protobuf
    libsystemtap
  ];

  cmakeDir = "../src";

  env.LDFLAGS = "-Wl,--copy-dt-needed-entries";

  cmakeFlags = [
    (lib.cmakeBool "XRT_NATIVE_BUILD" true)
    (lib.cmakeBool "XRT_SKIP_SUBMODULE_UPDATE" true)
  ];

  # Fix hardcoded paths for installation
  preInstall = ''
    find . -name cmake_install.cmake -exec sed -i \
      -e 's|/usr/src|'"$out"'/src|g' \
      -e 's|/usr/local/bin|'"$out"'/bin|g' \
      -e 's|/usr/local/lib|'"$out"'/lib|g' \
      -e 's|/usr/local|'"$out"'|g' \
      -e 's|/usr/lib|'"$out"'/lib|g' \
      -e 's|/usr/bin|'"$out"'/bin|g' \
      -e 's|/etc/OpenCL|'"$out"'/etc/OpenCL|g' \
      -e 's|/etc/|'"$out"'/etc/|g' \
      {} \;
  '';

  postInstall =
    # Fix double slash in pkgconfig files
    ''
      find $out -name "*.pc" -exec sed -i 's|//nix|/nix|g' {} \;
    ''
    # Fix nested installation paths
    # XRT cmake installs to $out/$out/... so we need to flatten
    + ''
      if [ -d "$out$out" ]; then
        cp -rn "$out$out"/* "$out/" || true
        rm -rf "$out/nix"
      fi
    '';

  passthru = {
    # XRT with AMD XDNA NPU support (Ryzen AI)
    xdna = callPackage ./xdna.nix { xrt = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Xilinx Runtime for FPGA/ACAP devices";
    homepage = "https://github.com/Xilinx/XRT";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ JohnMolotov ];
    platforms = lib.platforms.linux;
  };
})
