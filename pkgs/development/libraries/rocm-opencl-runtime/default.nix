{ stdenv
, lib
, fetchFromGitHub
, writeScript
, addOpenGLRunpath
, cmake
, rocm-cmake
, clang
, clang-unwrapped
, glew
, libglvnd
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

stdenv.mkDerivation rec {
  pname = "rocm-opencl-runtime";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-OpenCL-Runtime";
    rev = "rocm-${version}";
    hash = "sha256-4+PNxRqvAvU0Nj2igYl3WiS5h5HGV63J+cHbIVW89LE=";
  };

  nativeBuildInputs = [ cmake rocm-cmake ];

  buildInputs = [
    clang
    clang-unwrapped
    glew
    libglvnd
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

  # Remove clinfo, which is already provided through the
  # `clinfo` package.
  postInstall = ''
    rm -rf $out/bin
  '';

  # Fix the ICD installation path for NixOS
  postPatch = ''
    substituteInPlace khronos/icd/loader/linux/icd_linux.c \
      --replace 'ICD_VENDOR_PATH' '"${addOpenGLRunpath.driverLink}/etc/OpenCL/vendors/"'
    echo 'add_dependencies(amdocl64 OpenCL)' >> amdocl/CMakeLists.txt
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
    maintainers = with maintainers; [ acowley lovesegfault ];
    platforms = platforms.linux;
  };
}
