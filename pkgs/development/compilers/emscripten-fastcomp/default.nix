{ stdenv, fetchFromGitHub, cmake, python, ... }:

let
  rev = "1.36.4";
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
in
stdenv.mkDerivation rec {
  name = "emscripten-fastcomp-${rev}";

  src = fetchFromGitHub {
    owner = "kripken";
    repo = "emscripten-fastcomp";
    sha256 = "0838rl0n9hyq5dd0gmj5rvigbmk5mhrhzyjk0zd8mjs2mk8z510l";
    inherit rev;
  };

  srcFL = fetchFromGitHub {
    owner = "kripken";
    repo = "emscripten-fastcomp-clang";
    sha256 = "169hfabamv3jmf88flhl4scwaxdh24196gwpz3sdb26lzcns519q";
    inherit rev;
  };

  nativeBuildInputs = [ cmake python ];
  preConfigure = ''
    cp -Lr ${srcFL} tools/clang
    chmod +w -R tools/clang
  '';
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_TARGETS_TO_BUILD='X86;JSBackend'"
    "-DLLVM_INCLUDE_EXAMPLES=OFF"
    "-DLLVM_INCLUDE_TESTS=OFF"
    # "-DCLANG_INCLUDE_EXAMPLES=OFF"
    "-DCLANG_INCLUDE_TESTS=OFF"
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
    homepage = https://github.com/kripken/emscripten-fastcomp;
    description = "Emscripten LLVM";
    platforms = platforms.all;
    maintainers = with maintainers; [ qknight matthewbauer ];
    license = stdenv.lib.licenses.ncsa;
  };
}
