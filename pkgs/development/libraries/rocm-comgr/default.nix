{ stdenv, fetchFromGitHub, cmake, clang, device-libs, lld, llvm }:

stdenv.mkDerivation rec {
  pname = "rocm-comgr";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-CompilerSupport";
    rev = "rocm-${version}";
    hash = "sha256-JMzXg1Hw0iWcTnKu/NgW7rD8iagp724F01GaJbrJj9M=";
  };

  sourceRoot = "source/lib/comgr";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ clang device-libs lld llvm ];

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

  meta = with stdenv.lib; {
    description = "APIs for compiling and inspecting AMDGPU code objects";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/tree/amd-stg-open/lib/comgr";
    license = licenses.ncsa;
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.linux;
  };
}
