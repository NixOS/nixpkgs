{ stdenv
, lib
, fetchFromGitHub
, writeScript
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

stdenv.mkDerivation rec {
  pname = "rocm-opencl-runtime";
  version = "5.3.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-OpenCL-Runtime";
    rev = "rocm-${version}";
    hash = "sha256-QvAF25Zfq9d1M/KIsr2S+Ggxzqw/MQ2OVcm9ZNfjTa8=";
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
    "-DAMD_OPENCL_PATH=${src}"
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

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl -sL "https://api.github.com/repos/RadeonOpenCompute/ROCm-OpenCL-Runtime/tags" | jq '.[].name | split("-") | .[1] | select( . != null )' --raw-output | sort -n | tail -1)"
    update-source-version rocm-opencl-runtime "$version"
  '';

  meta = with lib; {
    description = "OpenCL runtime for AMD GPUs, part of the ROCm stack";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ acowley lovesegfault Flakebi ];
    platforms = platforms.linux;
  };
}
