{ lib
, fetchFromGitHub
, llvmPackages_15
, lld_15
, rocm-device-libs
, python3
, rocm-runtime
, cmake
, boost
, libxml2
, libffi
, makeWrapper
, hip
, rocmSupport ? false
}:
let
  inherit (llvmPackages_15) stdenv;
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
  ];

  buildInputs = [
    libxml2
    libffi
    boost
    llvmPackages_15.openmp
    llvmPackages_15.libclang.dev
    llvmPackages_15.llvm
  ] ++ lib.optionals rocmSupport [
    hip
    rocm-runtime
  ];

  # opensycl makes use of clangs internal headers. Its cmake does not successfully discover them automatically on nixos, so we supply the path manually
  cmakeFlags = [
    "-DCLANG_INCLUDE_PATH=${llvmPackages_15.libclang.dev}/include"
  ];

  postFixup = ''
    wrapProgram $out/bin/syclcc-clang \
      --prefix PATH : ${lib.makeBinPath [ python3 lld_15 ]} \
      --add-flags "-L${llvmPackages_15.openmp}/lib" \
      --add-flags "-I${llvmPackages_15.openmp.dev}/include" \
  '' + lib.optionalString rocmSupport ''
    --add-flags "--rocm-device-lib-path=${rocm-device-libs}/amdgcn/bitcode"
  '';

  meta = with lib; {
    homepage = "https://github.com/OpenSYCL/OpenSYCL";
    description = "Multi-backend implementation of SYCL for CPUs and GPUs";
    maintainers = with maintainers; [ yboettcher ];
    license = licenses.bsd2;
  };
}
