{ stdenv
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

  outputs = [ "out" "dev" ];

  postInstall = ''
    moveToOutput include "$dev"
    moveToOutput lib "$dev"

    # Fix lld binary path for CMake.
    substituteInPlace "$dev/lib/cmake/lld/LLDTargets-release.cmake" \
      --replace "\''${_IMPORT_PREFIX}/bin/lld" "$out/bin/lld"
  '';

  meta = with stdenv.lib; {
    description = "ROCm fork of the LLVM Linker";
    homepage = "https://github.com/RadeonOpenCompute/llvm-project";
    license = licenses.ncsa;
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.linux;
  };
}
