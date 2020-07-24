{ stdenv
, fetchFromGitHub
, addOpenGLRunpath
, cmake
, rocm-cmake
, clang
, clang-unwrapped
, libGLU
, libX11
, lld
, llvm
, mesa
, python2
, rocclr
, rocm-comgr
, rocm-device-libs
, rocm-runtime
, rocm-thunk
}:

let
  version = "3.5.0";
  tag = "roc-${version}";
in stdenv.mkDerivation rec {
  inherit version;

  pname = "rocm-opencl-runtime";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-OpenCL-Runtime";
    rev = tag;
    sha256 = "1wrr6mmn4gf6i0vxp4yqk0ny2wglvj1jfj50il8czjwy0cwmhykk";
    name = "ROCm-OpenCL-Runtime-${tag}-src";
  };

  nativeBuildInputs = [ cmake rocm-cmake ];

  buildInputs = [
    clang
    clang-unwrapped
    libGLU
    libX11
    lld
    llvm
    mesa
    python2
    rocclr
    rocm-comgr
    rocm-device-libs
    rocm-runtime
    rocm-thunk
  ];

  cmakeFlags = [
    "-DAMDGPU_TARGET_TRIPLE='amdgcn-amd-amdhsa'"
    "-DCLANG_OPTIONS_APPEND=-Wno-bitwise-conditional-parentheses"
    "-DClang_DIR=${clang-unwrapped}/lib/cmake/clang"
    "-DLIBROCclr_STATIC_DIR=${rocclr}/lib/cmake"
    "-DLLVM_DIR=${llvm.out}/lib/cmake/llvm"
    "-DUSE_COMGR_LIBRARY='yes'"
  ];

  dontStrip = true;

  # Fix the ICD installation path for NixOS
  postPatch = ''
    substituteInPlace khronos/icd/loader/linux/icd_linux.c \
      --replace 'ICD_VENDOR_PATH' '"${addOpenGLRunpath.driverLink}/etc/OpenCL/vendors/"'
    echo 'add_dependencies(amdocl64 OpenCL)' >> amdocl/CMakeLists.txt
  '';

  preFixup = ''
    patchelf --set-rpath "$out/lib" $out/bin/clinfo
  '';

  meta = with stdenv.lib; {
    description = "OpenCL runtime for AMD GPUs, part of the ROCm stack";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.linux;
  };
}
