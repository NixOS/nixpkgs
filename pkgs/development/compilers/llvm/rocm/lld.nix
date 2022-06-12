{ stdenv
, lib
, cmake
, libxml2
, llvm
, ninja

, version
, src
}:

stdenv.mkDerivation rec {
  inherit version src;

  sourceRoot = "${src.name}/lld";

  pname = "lld";

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [ libxml2 llvm ];

  outputs = [ "out" "dev" ];

  cmakeFlags = [ "-DLLVM_MAIN_SRC_DIR=${src}/llvm" ];

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"

    # Fix lld binary path for CMake.
    substituteInPlace "$dev/lib/cmake/lld/LLDTargets-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}/bin/lld" "$out/bin/lld"
  '';

  meta = with lib; {
    description = "ROCm fork of the LLVM Linker";
    homepage = "https://github.com/RadeonOpenCompute/llvm-project";
    license = licenses.ncsa;
    maintainers = with maintainers; [ acowley lovesegfault ];
    platforms = platforms.linux;
  };
}
