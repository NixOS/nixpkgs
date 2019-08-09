{ emscriptenVersion, stdenv, fetchFromGitHub, cmake, python, gtest, ... }:

let
  rev = emscriptenVersion;
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
in
stdenv.mkDerivation rec {
  name = "emscripten-fastcomp-${rev}";

  src = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten-fastcomp";
    sha256 = "0bd0l5k2fa4k0nax2cpxi003pqffqivx4z4m2j5xdha1a12sid8i";
    inherit rev;
  };

  srcFL = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten-fastcomp-clang";
    sha256 = "1iw2qplhp489qzw0rma73sab7asnm27g4m95sr36c6kq9cq6agri";
    inherit rev;
  };

  nativeBuildInputs = [ cmake python gtest ];
  preConfigure = ''
    cp -Lr ${srcFL} tools/clang
    chmod +w -R tools/clang
  '';
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_TARGETS_TO_BUILD='X86;JSBackend'"
    "-DLLVM_INCLUDE_EXAMPLES=OFF"
    "-DLLVM_INCLUDE_TESTS=ON"
    #"-DLLVM_CONFIG=${llvm}/bin/llvm-config"
    "-DLLVM_BUILD_TESTS=ON"
    "-DCLANG_INCLUDE_TESTS=ON"
  ] ++ (stdenv.lib.optional stdenv.isLinux
    # necessary for clang to find crtend.o
    "-DGCC_INSTALL_PREFIX=${gcc}"
  );
  enableParallelBuilding = true;

  passthru = {
    isClang = true;
    inherit gcc;
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/emscripten-core/emscripten-fastcomp;
    description = "Emscripten LLVM";
    platforms = platforms.all;
    maintainers = with maintainers; [ qknight matthewbauer ];
    license = stdenv.lib.licenses.ncsa;
  };
}
