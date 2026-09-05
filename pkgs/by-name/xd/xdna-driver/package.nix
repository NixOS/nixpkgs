{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  xrt,
  boost,
  rapidjson,
  libdrm,
  elfutils,
  libuuid,
  libsystemtap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdna-driver";
  version = "2.21.75";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "xdna-driver";
    tag = finalAttrs.version;
    hash = "sha256-pc9ou88iNAQpjcFvv9NluF8ag87v1KA/14bgfKWe0NE=";
  };

  patches = [ ./use_system_xrt.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    xrt
    boost
    rapidjson
    libdrm
    elfutils
    libuuid
    libsystemtap
  ];

  cmakeFlags = [
    # We have this in kernels we ship already
    (lib.cmakeBool "SKIP_KMOD" true)
    (lib.cmakeBool "XRT_UPSTREAM" true)
    (lib.cmakeFeature "XRT_SOURCE_DIR" "${xrt.src}/src")
  ];

  meta = {
    description = "XRT SHIM library for AMD XDNA";
    homepage = "https://github.com/amd/xdna-driver";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
