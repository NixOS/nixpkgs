{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,

  # nativeBuildInputs
  cmake,
  gawk,
  gitMinimal,
  pkg-config,
  python3,

  xrt,
  boost,
  libdrm,
  libuuid,
  libelf,
  ocl-icd,
  opencl-headers,
  ncurses,
  libxml2,
  yaml-cpp,
  openssl,
  rapidjson,
  protobuf,
  systemd,
  libsystemtap,
}:

let
  # The CMake configuration (here and in the bundled XRT) shells out to the build machine's
  # /etc/os-release. It is absent in the sandbox, making the build depend on the host.
  osRelease = writeText "os-release" ''
    ID=nixos
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xrt-amdxdna-plugin";
  inherit (xrt) version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "amd";
    repo = "xdna-driver";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-bBiI42bwap6O59MQdIylX7uz+fLUF75RTyNWTJfAFds=";
  };

  postPatch = ''
    substituteInPlace CMake/pkg.cmake xrt/src/CMake/nativeLnx.cmake xrt/src/CMake/cpackLin.cmake \
      --replace-fail \
        /etc/os-release \
        ${osRelease}
  ''
  # XDNA_BIN_DIR holds a second copy of the built libraries "for quick testing" at an absolute
  # path, which CMake installs below the prefix. Point it at the prefix itself instead.
  + ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'set(XDNA_BIN_DIR      /bins)' \
        'set(XDNA_BIN_DIR      .)'
  ''
  # `std::memory_order` is a scoped enum since C++20 (needed for abseil), as already fixed upstream
  + ''
    substituteInPlace src/shim/umq/hwq.cpp src/shim/umq/dbg_hwq.cpp \
      --replace-fail \
        'std::memory_order::memory_order_seq_cst' \
        'std::memory_order_seq_cst'
  '';

  nativeBuildInputs = [
    cmake
    gawk
    gitMinimal
    pkg-config
    python3
  ];

  buildInputs = [
    xrt
    boost
    libdrm
    libuuid
    libelf
    ocl-icd
    opencl-headers
    ncurses
    libxml2
    yaml-cpp
    openssl
    rapidjson
    protobuf
    systemd
    libsystemtap
  ];

  env.LDFLAGS = "-Wl,--copy-dt-needed-entries";

  cmakeFlags = [
    # The bundled XRT derives its own install directories by appending CMAKE_INSTALL_*DIR to the
    # prefix, so the absolute values set by the cmake setup hook would install into `$out/$out`.
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_DATADIR" "share")
    # abseil (pulled in through protobuf) requires C++20, but XRT defaults to C++17
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "20")
    (lib.cmakeBool "SKIP_KMOD" true)
    # Keep the soname of the bundled XRT libraries in sync with the xrt package
    (lib.cmakeFeature "XRT_BUILD_NUMBER" (lib.versions.patch finalAttrs.version))
  ];

  meta = {
    description = "AMD XDNA driver userspace plugin for XRT";
    homepage = "https://github.com/amd/xdna-driver";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      JohnMolotov
    ];
    platforms = lib.platforms.linux;
  };
})
