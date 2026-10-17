{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  cmake,
  pkg-config,
  removeReferencesTo,
  makeBinaryWrapper,
  boost,
  libdrm,
  ocl-icd,
  protobuf,
  rapidjson,
  opencl-headers,
  ncurses,
  openssl,
  curl,
  libuuid,
  libsystemtap,
  systemdLibs,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrt";
  version = "2.21.75";

  src = fetchFromGitHub {
    owner = "Xilinx";
    repo = "XRT";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-sujiSRZuIelhvUew7yeCfApAmp/Pf2+F38KO9cxI2HE=";
  };

  postPatch = ''
    substituteInPlace src/python/pybind11/CMakeLists.txt \
      --replace-fail "/usr/bin/python3" "${lib.getExe python3Packages.python}"

    # Correct reference to $lib (for module/shim)
    substituteInPlace src/runtime_src/core/common/detail/linux/xilinx_xrt.h \
      --replace-fail "sfs::path(XRT_INSTALL_PREFIX);" "sfs::path(\"$lib\");"
  '';

  patches = [
    # Fixing tons of non-standard prefixes
    ./fix_install_path.patch
    ./aiebu_fix_install_path.patch

    ./fix_dynamic_loading.patch
  ];

  outputs = [
    "out"
    "dev"
    "lib"
    # kernel module source
    "dkms"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    removeReferencesTo
    makeBinaryWrapper
  ];

  buildInputs = [
    boost
    libdrm
    ocl-icd
    protobuf
    rapidjson
    opencl-headers
    ncurses
    openssl
    curl
    libuuid
    libsystemtap
    systemdLibs
    bash
    python3Packages.python
    python3Packages.pybind11
  ];

  strictDeps = true;

  cmakeFlags = [
    # Don't download dependencies
    (lib.cmakeBool "XRT_UPSTREAM_DEBIAN" true)
    (lib.cmakeBool "XRT_AIE_BUILD" true)
    (lib.cmakeBool "XRT_ALVEO" true)
    (lib.cmakeBool "XRT_NPU" true)
  ];

  postInstall = ''
    mkdir -p $dkms
    mv $out/src/* $dkms/
    rm -r $out/src
    rm -r $out/license
    rm $out/version.json
  '';

  postFixup = ''
    # Fix path in auto-generated cmake file
    substituteInPlace $dev/lib/cmake/{AIEBU/aiebu-targets.cmake,XRT/xrt-targets.cmake} \
      --replace-fail "set(_IMPORT_PREFIX \"$out\")" "set(_IMPORT_PREFIX \"$dev\")"

    substituteInPlace $out/bin/xbtop \
      --replace-fail "python3" "${lib.getExe python3Packages.python}" \
      --replace-fail "../python" "../share/XRT/python"
  '';

  meta = {
    description = "Run Time for AIE and FPGA based platforms";
    longDescription = ''
      Xilinx Runtime (XRT) is implemented as as a combination
      of userspace and kernel driver components. XRT supports
      both PCIe based boards like U30, U50, U200, U250, U280,
      VCK190 and MPSoC based embedded platforms. XRT provides
      a standardized software interface to Xilinx FPGA. The
      key user APIs are defined in xrt.h header file.
    '';
    homepage = "https://xilinx.github.io/XRT";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
