{ lib
, fetchFromGitHub
, llvmPackages_15
, lld_15
, python3
, cmake
, boost
, libxml2
, libffi
, makeWrapper
, config
, cudaPackages
, rocmPackages_5
, ompSupport ? true
, openclSupport ? false
, rocmSupport ? config.rocmSupport
, cudaSupport ? config.cudaSupport
, autoAddDriverRunpath
}:
let
  inherit (llvmPackages_15) stdenv;
  # move to newer ROCm version once supported
  rocmPackages = rocmPackages_5;
in
stdenv.mkDerivation rec {
  pname = "OpenSYCL";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "OpenSYCL";
    repo = "OpenSYCL";
    rev = "v${version}";
    sha256 = "sha256-5YkuUOAnvoAD5xDKxKMPq0B7+1pb6hVisPAhs0Za1ls=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ] ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    libxml2
    libffi
    boost
    llvmPackages_15.openmp
    llvmPackages_15.libclang.dev
    llvmPackages_15.llvm
  ] ++ lib.optionals rocmSupport [
    rocmPackages.clr
    rocmPackages.rocm-runtime
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    (lib.getOutput "stubs" cudaPackages.cuda_cudart)
  ];

  # opensycl makes use of clangs internal headers. Its cmake does not successfully discover them automatically on nixos, so we supply the path manually
  cmakeFlags = [
    "-DCLANG_INCLUDE_PATH=${llvmPackages_15.libclang.dev}/include"
    (lib.cmakeBool "WITH_CPU_BACKEND" ompSupport)
    (lib.cmakeBool "WITH_CUDA_BACKEND" cudaSupport)
    (lib.cmakeBool "WITH_ROCM_BACKEND" rocmSupport)
  ] ++ lib.optionals (lib.versionAtLeast version "24") [
    (lib.cmakeBool "WITH_OPENCL_BACKEND" openclSupport)
  ];

  postFixup = ''
    wrapProgram $out/bin/syclcc-clang \
      --prefix PATH : ${lib.makeBinPath [ python3 lld_15 ]} \
      --add-flags "-L${llvmPackages_15.openmp}/lib" \
      --add-flags "-I${llvmPackages_15.openmp.dev}/include" \
  '' + lib.optionalString rocmSupport ''
    --add-flags "--rocm-device-lib-path=${rocmPackages.rocm-device-libs}/amdgcn/bitcode"
  '';

  meta = with lib; {
    homepage = "https://github.com/OpenSYCL/OpenSYCL";
    description = "Multi-backend implementation of SYCL for CPUs and GPUs";
    maintainers = with maintainers; [ yboettcher ];
    license = licenses.bsd2;
  };
}
