# This is what nvcc uses as a backend,
# and it has to be an officially supported one (e.g. gcc11 for cuda11).
#
# It, however, propagates current stdenv's libstdc++ to avoid "GLIBCXX_* not found errors"
# when linked with other C++ libraries.
# E.g. for cudaPackages_11_8 we use gcc11 with gcc12's libstdc++
# Cf. https://github.com/NixOS/nixpkgs/pull/218265 for context
{
  _cuda,
  cudaMajorMinorVersion,
  flags,
  lib,
  pkgs,
  stdenv,
  stdenvAdapters,
}:
let
  inherit (lib.customisation) extendDerivation;
  inherit (_cuda.db) nvccCompatibilities;

  passthruExtra = {
    nvccHostCCMatchesStdenvCC = backendStdenv.cc == stdenv.cc;
  };

  assertCondition = flags != { };
  backendStdenv =
    stdenvAdapters.useLibsFrom stdenv
      pkgs."gcc${nvccCompatibilities.${cudaMajorMinorVersion}.gcc.maxMajorVersion}Stdenv";
in
# TODO: Consider testing whether we in fact use the newer libstdc++
extendDerivation assertCondition passthruExtra backendStdenv
