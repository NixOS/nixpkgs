{ stdenv
, lib
, fetchFromGitHub
, rocmUpdateScript
, addOpenGLRunpath
, cmake
, rocm-cmake
, clang
, glew
, libglvnd
, libX11
, llvm
, mesa
, numactl
, python3
, rocclr
, rocm-comgr
, rocm-device-libs
, rocm-runtime
, rocm-thunk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-opencl-runtime";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-OpenCL-Runtime";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-E1+Y/fgp5b+7H1LN+O1fwVi0/XRCgvsiSxTY3u/q+8I=";
  };

  nativeBuildInputs = [ cmake rocm-cmake ];

  buildInputs = [
    clang
    glew
    libglvnd
    libX11
    llvm
    mesa
    numactl
    python3
    rocm-comgr
    rocm-device-libs
    rocm-runtime
    rocm-thunk
  ];

  cmakeFlags = [
    "-DAMD_OPENCL_PATH=${finalAttrs.src}"
    "-DROCCLR_PATH=${rocclr}"
    "-DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm/opencl"
  ];

  dontStrip = true;

  # Remove clinfo, which is already provided through the
  # `clinfo` package.
  postInstall = ''
    rm -rf $out/bin
  '';

  # Fix the ICD installation path for NixOS
  postPatch = ''
    substituteInPlace khronos/icd/loader/linux/icd_linux.c \
      --replace 'ICD_VENDOR_PATH' '"${addOpenGLRunpath.driverLink}/etc/OpenCL/vendors/"'
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "OpenCL runtime for AMD GPUs, part of the ROCm stack";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ acowley lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
