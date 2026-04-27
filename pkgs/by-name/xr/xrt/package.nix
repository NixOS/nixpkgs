{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  cmake,
  pkg-config,
  git,
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

  src = fetchFromGitHub {
    owner = "Xilinx";
    repo = "XRT";
    rev = finalAttrs.version;
    hash = "sha256-sujiSRZuIelhvUew7yeCfApAmp/Pf2+F38KO9cxI2HE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    git
    curl
  ];

  buildInputs = [
    boost
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

  postPatch = ''
    # Disable static aiebu utilities which require static glibc
    substituteInPlace src/runtime_src/core/common/aiebu/src/cpp/utils/CMakeLists.txt \
      --replace-fail "add_subdirectory(asm)" "" \
      --replace-fail "add_subdirectory(dump)" ""
    # Disable aiebu tests that reference the disabled utilities
    substituteInPlace src/runtime_src/core/common/aiebu/CMakeLists.txt \
      --replace-fail "add_subdirectory(test)" ""
  '';

  cmakeFlags = [
    "-DXRT_NATIVE_BUILD=yes"
    "-DXRT_SKIP_SUBMODULE_UPDATE=yes"
  ];

  preBuild = ''
    # Fix hardcoded /usr/src path for driver installation
    find . -name cmake_install.cmake -exec sed -i 's|/usr/src|'"$out"'/src|g' {} \; || true
  '';

  preInstall = ''
    # Fix hardcoded paths for installation
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

  postInstall = ''
    # Fix double slash in pkgconfig files
    find $out -name "*.pc" -exec sed -i 's|//nix|/nix|g' {} \;

    # Fix nested installation paths
    # XRT cmake installs to $out/$out/... so we need to flatten
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
