{ lib, stdenv
, buildLlvmTools
, cmake
, libxml2
, llvm

, version
, src
}:

stdenv.mkDerivation rec {
  inherit version src;

  pname = "lld";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libxml2 llvm ];


  cmakeFlags = [
    "-DLLVM_MAIN_SRC_DIR=${llvm.src}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DLLVM_TABLEGEN_EXE=${buildLlvmTools.llvm}/bin/llvm-tblgen"
    "-DLLVM_CONFIG_PATH=${llvm.dev}/bin/llvm-config-native"
  ];

  outputs = [ "out" "dev" ];

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
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
