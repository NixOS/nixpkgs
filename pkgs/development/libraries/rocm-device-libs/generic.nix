{ stdenv
, fetchFromGitHub
, cmake
, clang
, lld
, llvm
, rocr

, source ? null
, tagPrefix ? null
, sha256 ? null
}:
# Caller *must* provide either source or both tagPrefix and sha256
assert (isNull source) -> !(isNull tagPrefix || isNull sha256);
let
  version = "3.3.0";
  srcTmp =
    if isNull source then fetchFromGitHub {
      owner = "RadeonOpenCompute";
      repo = "ROCm-Device-Libs";
      rev = "${tagPrefix}-${version}";
      inherit sha256;
    } else source;
in
stdenv.mkDerivation rec {
  inherit version;

  pname = "rocm-device-libs";

  src = srcTmp;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ clang lld llvm rocr ];

  cmakeBuildType = "Release";

  cmakeFlags = [
    "-DLLVM_TARGETS_TO_BUILD='AMDGPU;X86'"
    "-DLLVM_DIR=${llvm}/lib/cmake/llvm"
    "-DCLANG_OPTIONS_APPEND='-Wno-unused-command-line-argument;-Wno-bitwise-conditional-parentheses'"
  ];

  patchPhase = ''
    substituteInPlace OCL.cmake \
      --replace 'set(CLANG "''${LLVM_TOOLS_BINARY_DIR}/clang''${EXE_SUFFIX}")' 'set(CLANG "${clang}/bin/clang")'
  '';

  meta = with stdenv.lib; {
    description = "Set of AMD-specific device-side language runtime librariesr";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-Device-Libs";
    license = licenses.ncsa;
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.linux;
  };
}
