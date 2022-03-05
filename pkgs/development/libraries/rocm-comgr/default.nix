{ lib, stdenv, fetchFromGitHub, writeScript, cmake, clang, rocm-device-libs, lld, llvm }:

stdenv.mkDerivation rec {
  pname = "rocm-comgr";
  version = "4.5.2";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-CompilerSupport";
    rev = "rocm-${version}";
    hash = "sha256-enGzu1EOo87/S5oH1eEqPy0AtsBhCcroG3DYemeNgR0=";
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

  # The comgr build tends to link against the static LLVM libraries
  # *and* the dynamic library. Linking against both causes errors
  # about command line options being registered twice. This patch
  # removes the static library linking.
  patchPhase = ''
    sed -e '/^llvm_map_components_to_libnames/,/[[:space:]]*Symbolize)/d' \
        -i CMakeLists.txt
  '';

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
