{
  pkgs,
  xla,
  cudaPackages,
  expectSelectedOutput ? false,
}:
let
  inherit (pkgs) lib;
  local = pkgs.callPackage ../cuda-local.nix { inherit cudaPackages; };
  expected = pkgs.writeText "xla-cuda-configure-expected.json" (
    builtins.toJSON {
      inherit (cudaPackages.flags) realArches virtualArches cudaForwardCompat;
    }
  );
in
xla.overrideAttrs {
  name = "${xla.name}-cuda-configure";
  # Regenerate repositories and compile one real CUDA translation unit, not XLA.
  # Local repository inputs include selected NCCL, possibly requiring its build.
  # Keep the layout views out of autoPatchelf's search path.
  buildInputs = with pkgs; [
    elfutils
    glibc
    libxml2
    ncurses5
    ncurses
    stdenv.cc.cc.lib
    zlib
  ];
  runtimeDependencies = [ ];
  buildPhase = ''
    runHook preBuild
    concatTo bazelFlagsArray bazelFlags
    BAZEL_USE_CPP_ONLY_TOOLCHAIN=1 USER=homeless-shelter bazel --batch \
      --output_base="$bazelOut" --output_user_root="$bazelUserRoot" \
      build --nobuild --curses=no "''${bazelFlagsArray[@]}" @local_config_cuda//... @local_config_nccl//:nccl @cuda_nccl//:nccl || {
        ls -la "$bazelOut/external/local_config_nccl" >&2 || true
        exit 1
      }
    test "$(readlink -f "$bazelOut/external/cuda_nvcc/bin/nvcc")" = "$(readlink -f '${local.cuda}/bin/nvcc')"
    test "$(readlink "$bazelOut/external/cuda_cudnn/include")" = '${local.cudnn}/include'
    test "$(readlink "$bazelOut/external/cuda_nccl/include")" = '${local.nccl}/include'
    test "$(readlink -f "$bazelOut/external/cuda_nccl/lib/libnccl.so")" = "$(readlink -f '${lib.getLib cudaPackages.nccl}/lib/libnccl.so')"
    test ! -L "$bazelOut/external/cuda_cccl/libcudacxx"
    ${pkgs.bash}/bin/bash ${./cuda-driver-check.sh} \
      "$bazelOut/external/cuda_driver" '${local.cuda}/lib/stubs/libcuda.so'
    ${lib.optionalString expectSelectedOutput ''
      test -e "$bazelOut/external/cuda_nccl/include/xla-selected-nccl-output.h"
    ''}
    cp ${./cuda-compile.cu} build_tools/configure/assert_nvcc.cu.cc
    BAZEL_USE_CPP_ONLY_TOOLCHAIN=1 USER=homeless-shelter bazel --batch \
      --output_base="$bazelOut" --output_user_root="$bazelUserRoot" \
      build --subcommands --curses=no "''${bazelFlagsArray[@]}" \
      ${lib.optionalString expectSelectedOutput "--copt=-DXLA_TEST_SELECTED_OUTPUT"} \
      //build_tools/configure:assert_nvcc
    ${lib.getExe pkgs.python3} ${./cuda-configure-check.py} \
      "$bazelOut/external/local_config_cuda/cuda" ${expected}
    runHook postBuild
  '';
  installPhase = ''
    mkdir -p "$out"
    cp "$bazelOut/external/local_config_cuda/cuda/cuda/cuda_config.py" "$out/"
    cp "$bazelOut/external/local_config_cuda/cuda/build_defs.bzl" "$out/"
    cp xla_configure.bazelrc "$out/"
    cp ${expected} "$out/expected.json"
    cp "$bazelOut/external/cuda_nccl/BUILD" "$out/nccl.BUILD"
    cp "$bazelOut/external/cuda_nccl/version.bzl" "$out/nccl-version.bzl"
    cp bazel-bin/build_tools/configure/libassert_nvcc.a "$out/cuda-compile-probe.a"
  '';
  dontFixup = true;
  # This is a build-configuration check, not another package to test recursively.
  passthru = { };
}
