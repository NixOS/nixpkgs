{
  lib,
  stdenv,
  # The directory of the host compiler, which the wrapper puts on PATH.
  compilerBindir,
  # Whether nvcc has --frandom-seed.
  frandomSeed,
}:
# The nvcc wrapper, which cuda_nvcc installs as bin/nvcc; see README.md. It runs .nvcc-wrapped from its own directory.
# It is built with the ordinary stdenv, once for each host compiler and for whether nvcc has --frandom-seed.
stdenv.mkDerivation {
  __structuredAttrs = true;
  strictDeps = true;

  name = "nvcc-wrapper";

  src = ./wrappers;

  dontConfigure = true;

  # NOTE: libstdc++ is linked statically, as nvcc doesn't use it and may run with an incompatible one on
  # LD_LIBRARY_PATH (e.g. from JAX).
  buildPhase = ''
    runHook preBuild
    "$CXX" -std=c++23 -O2 -Wall -Wextra -static-libstdc++ -static-libgcc \
      -DNVCC_WRAPPER_COMPILER_BINDIR='"${compilerBindir}"' \
      -DNVCC_WRAPPER_FRANDOM_SEED=${if frandomSeed then "1" else "0"} \
      nvcc-wrapper.cpp -o nvcc-wrapper
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D --mode=0755 nvcc-wrapper "$out/bin/nvcc-wrapper"
    runHook postInstall
  '';

  meta = {
    description = "Wrapper for nvcc which makes its output reproducible";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cuda ];
  };
}
