{
  lib,
  stdenv,
}:
# The nvlink wrapper, which cuda_nvcc installs as bin/nvlink; see README.md. It runs .nvlink-wrapped from its own
# directory, so it doesn't depend on the CUDA release and is built once with the ordinary stdenv.
stdenv.mkDerivation {
  __structuredAttrs = true;
  strictDeps = true;

  name = "nvlink-wrapper";

  src = ./nvlink-wrapper.cpp;

  dontUnpack = true;
  dontConfigure = true;

  # NOTE: libstdc++ is linked statically, as nvlink doesn't use it and may run with an incompatible one on
  # LD_LIBRARY_PATH (e.g. from JAX).
  buildPhase = ''
    runHook preBuild
    "$CXX" -std=c++23 -O2 -Wall -Wextra -static-libstdc++ -static-libgcc "$src" -o nvlink-wrapper
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D --mode=0755 nvlink-wrapper "$out/bin/nvlink-wrapper"
    runHook postInstall
  '';

  meta = {
    description = "Wrapper for nvlink which removes references to the Nix store from its output";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cuda ];
  };
}
