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
    sha256 = "03czd9hkgn8xn4jyiqf7qxmv9fxi6ryjvkzfv9163mc52vq91i1z";
    inherit rev;
  };

  srcFL = fetchFromGitHub {
    owner = "emscripten-core";
    repo = "emscripten-fastcomp-clang";
    sha256 = "0bpsbbb0z6k8lzd5gj6c5377gsyzzpsdiq1m3gsx5c5qxnsa0shv";
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
