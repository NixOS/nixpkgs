{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, addOpenGLRunpath
, cmake
, rocm-comgr
, rocm-runtime
, rocclr
, glew
, libX11
, numactl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-opencl-runtime";
  version = "5.4.3";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-OpenCL-Runtime";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-E1+Y/fgp5b+7H1LN+O1fwVi0/XRCgvsiSxTY3u/q+8I=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    rocm-comgr
    rocm-runtime
    glew
    libX11
    numactl
  ];

  cmakeFlags = [
    "-DAMD_OPENCL_PATH=${finalAttrs.src}"
    "-DROCCLR_PATH=${rocclr}"
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
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
