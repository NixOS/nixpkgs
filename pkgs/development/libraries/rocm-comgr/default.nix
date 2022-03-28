{ lib, stdenv, fetchFromGitHub, writeScript, cmake, clang, rocm-device-libs, lld, llvm }:

stdenv.mkDerivation rec {
  pname = "rocm-comgr";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-CompilerSupport";
    rev = "rocm-${version}";
    hash = "sha256-EIBH7TXelo6mr+/vJ+iT+VLUVoQqWmNsgeN3Nwwr+tM=";
  };

  sourceRoot = "source/lib/comgr";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ clang rocm-device-libs lld llvm ];

  cmakeFlags = [
    "-DCLANG=${clang}/bin/clang"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_C_COMPILER=${clang}/bin/clang"
    "-DCMAKE_CXX_COMPILER=${clang}/bin/clang++"
    "-DCMAKE_PREFIX_PATH=${llvm}/lib/cmake/llvm"
    "-DLLD_INCLUDE_DIRS=${lld.src}/include"
    "-DLLVM_TARGETS_TO_BUILD=\"AMDGPU;X86\""
  ];

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl -sL "https://api.github.com/repos/RadeonOpenCompute/ROCm-CompilerSupport/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rocm-comgr "$version"
  '';

  meta = with lib; {
    description = "APIs for compiling and inspecting AMDGPU code objects";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/tree/amd-stg-open/lib/comgr";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
  };
}
