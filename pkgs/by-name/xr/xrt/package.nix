{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,

  # nativeBuildInputs
  cmake,
  pkg-config,
  gitMinimal,

  # buildInputs
  boost,
  curl,
  libdrm,
  libsystemtap,
  libuuid,
  libxml2,
  ncurses,
  ocl-icd,
  opencl-headers,
  openssl,
  protobuf,
  rapidjson,
  systemd,
  yaml-cpp,

  # passthru
  callPackage,
}:

let
  # The CMake configuration shells out to the build machine's /etc/os-release to detect the
  # distribution. It is absent in the sandbox, which breaks the configure step.
  osRelease = writeText "os-release" ''
    ID=nixos
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xrt";
  # `xrt-amdxdna-plugin` tracks this version tag-for-tag, so both must be updated together
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

  postPatch = ''
    substituteInPlace src/CMake/nativeLnx.cmake src/CMake/cpackLin.cmake \
      --replace-fail \
        /etc/os-release \
        ${osRelease}
  ''
  # The aiebu utilities are linked with `-static`, which would require a static glibc, boost and
  # libstdc++. Upstream already gates that on AIEBU_UPSTREAM ("upstreaming does not allow
  # statically linked executables"), but ties it to a full XRT_UPSTREAM build, which drops the
  # XDP profiling plugins. Just turn it on.
  + ''
    substituteInPlace src/runtime_src/core/common/CMakeLists.txt \
      --replace-fail \
        'set(AIEBU_UPSTREAM ''${XRT_UPSTREAM})' \
        'set(AIEBU_UPSTREAM 1)'
  ''
  # A handful of install destinations are hardcoded to absolute FHS paths, which CMake then
  # installs *below* the prefix (`$out/nix/store/...-xrt/etc/OpenCL`). Make them relative so
  # that they land where they belong.
  + ''
    substituteInPlace src/CMake/icd.cmake \
      --replace-fail \
        '"/etc/OpenCL/vendors"' \
        '"etc/OpenCL/vendors"'

    substituteInPlace src/CMake/dkms.cmake src/CMake/version.cmake \
      --replace-fail \
        '"/usr/src/xrt-' \
        '"src/xrt-'

    substituteInPlace src/CMake/dkms-aws.cmake \
      --replace-fail \
        '"/usr/src/xrt-aws-' \
        '"src/xrt-aws-'

    substituteInPlace \
        src/runtime_src/core/tools/xbflash2/CMakeLists.txt \
        src/runtime_src/core/pcie/tools/xbflash.qspi/CMakeLists.txt \
      --replace-fail \
        '"/usr/local/bin"' \
        '"bin"'
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
    gitMinimal
    pkg-config
  ];

  buildInputs = [
    boost
    curl
    libdrm
    libsystemtap
    libuuid
    libxml2
    ncurses
    ocl-icd
    opencl-headers
    openssl
    protobuf
    rapidjson
    systemd
    yaml-cpp
  ];

  cmakeDir = "../src";

  env.LDFLAGS = "-Wl,--copy-dt-needed-entries";

  cmakeFlags = [
    # XRT derives its own install directories by appending CMAKE_INSTALL_*DIR to the prefix, so
    # the absolute values set by the cmake setup hook would install everything into `$out/$out`.
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    # abseil (pulled in through protobuf) requires C++20, but XRT defaults to C++17
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "20")
    (lib.cmakeBool "XRT_NATIVE_BUILD" true)
    (lib.cmakeBool "XRT_SKIP_SUBMODULE_UPDATE" true)
    # XRT_VERSION_PATCH is reset by `project(xrt)`, so it has to be passed as XRT_BUILD_NUMBER.
    # Without it the libraries end up versioned 2.21.0 instead of 2.21.75.
    (lib.cmakeFeature "XRT_BUILD_NUMBER" (lib.versions.patch finalAttrs.version))
  ];

  passthru = {
    # Bumping xrt on its own breaks xrt-amdxdna-plugin, which reuses this version as its source tag
    skipBulkUpdate = true;

    # XRT with AMD XDNA NPU support (Ryzen AI)
    xdna = callPackage ./xdna.nix { xrt = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Xilinx Runtime for FPGA/ACAP devices";
    homepage = "https://github.com/Xilinx/XRT";
    changelog = "https://github.com/Xilinx/XRT/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ JohnMolotov ];
    platforms = lib.platforms.linux;
  };
})
