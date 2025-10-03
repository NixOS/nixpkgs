{
  _cuda,
  backendStdenv,
  buildRedist,
  cuda_cudart,
  cudnn,
  cuda_nvrtc,
  lib,
  libcudla, # only for Jetson
  patchelf,
}:
let
  inherit (_cuda.lib) majorMinorPatch;
  inherit (backendStdenv) hasJetsonCudaCapability;
  inherit (lib.attrsets) getLib;
  inherit (lib.lists) optionals;
  inherit (lib.strings) concatStringsSep;
in
buildRedist (
  finalAttrs:
  let
    majorMinorPatchVersion = majorMinorPatch finalAttrs.version;
    majorVersion = lib.versions.major finalAttrs.version;
  in
  {
    redistName = "tensorrt";
    pname = "tensorrt";

    outputs = [
      "out"
      "bin"
      "dev"
      "include"
      "lib"
      "samples"
      "static"
      # "stubs" removed in postInstall
    ];

    allowFHSReferences = true;

    nativeBuildInputs = [ patchelf ];

    buildInputs = [
      (getLib cudnn)
      (getLib cuda_nvrtc)
      cuda_cudart
    ]
    ++ optionals libcudla.meta.available [ libcudla ];

    preInstall =
      let
        inherit (backendStdenv.hostPlatform) parsed;
        # x86_64-linux-gnu
        targetString = concatStringsSep "-" [
          parsed.cpu.name
          parsed.kernel.name
          parsed.abi.name
        ];
      in
      # Replace symlinks to bin and lib with the actual directories from targets.
      ''
        for dir in bin lib; do
          [[ -L "$dir" ]] || continue
          nixLog "replacing symlink $NIX_BUILD_TOP/$sourceRoot/$dir with $NIX_BUILD_TOP/$sourceRoot/targets/${targetString}/$dir"
          rm --verbose "$NIX_BUILD_TOP/$sourceRoot/$dir"
          mv --verbose --no-clobber "$NIX_BUILD_TOP/$sourceRoot/targets/${targetString}/$dir" "$NIX_BUILD_TOP/$sourceRoot/$dir"
        done
        unset -v dir
      ''
      # Remove symlinks if they exist
      + ''
        for dir in include samples; do
          if [[ -L "$NIX_BUILD_TOP/$sourceRoot/targets/${targetString}/$dir" ]]; then
            nixLog "removing symlink $NIX_BUILD_TOP/$sourceRoot/targets/${targetString}/$dir"
            rm --verbose "$NIX_BUILD_TOP/$sourceRoot/targets/${targetString}/$dir"
          fi
        done
        unset -v dir

        if [[ -d "$NIX_BUILD_TOP/$sourceRoot/targets" ]]; then
          nixLog "removing targets directory"
          rm --recursive --verbose "$NIX_BUILD_TOP/$sourceRoot/targets" || {
            nixErrorLog "could not delete $NIX_BUILD_TOP/$sourceRoot/targets: $(ls -laR "$NIX_BUILD_TOP/$sourceRoot/targets")"
            exit 1
          }
        fi
      '';

    autoPatchelfIgnoreMissingDeps = optionals hasJetsonCudaCapability [
      "libnvdla_compiler.so"
    ];

    # Create a symlink for the Onnx header files in include/onnx
    # NOTE(@connorbaker): This is shared with the tensorrt-oss package, with the `out` output swapped with `include`.
    # When updating one, check if the other should be updated.
    postInstall = ''
      mkdir "''${!outputInclude:?}/include/onnx"
      pushd "''${!outputInclude:?}/include" >/dev/null
      nixLog "creating symlinks for Onnx header files"
      ln -srvt "''${!outputInclude:?}/include/onnx/" NvOnnx*.h
      popd >/dev/null
    ''
    # Move the python directory, which contains header files, to the include output.
    + ''
      nixLog "moving python directory to include output"
      moveToOutput python "''${!outputInclude:?}"

      nixLog "remove python wheels"
      rm --verbose "''${!outputInclude:?}"/python/*.whl
    ''
    + ''
      nixLog "moving data directory to samples output"
      moveToOutput data "''${!outputSamples:?}"
    ''
    # Remove the Windows library used for cross-compilation if it exists.
    + ''
      if [[ -e "''${!outputLib:?}/lib/libnvinfer_builder_resource_win.so.${majorMinorPatchVersion}" ]]; then
        nixLog "removing Windows library"
        rm --verbose "''${!outputLib:?}/lib/libnvinfer_builder_resource_win.so.${majorMinorPatchVersion}"
      fi
    ''
    # Remove the stub libraries.
    + ''
      nixLog "removing stub libraries"
      rm --recursive --verbose "''${!outputLib:?}/lib/stubs" || {
        nixErrorLog "could not delete ''${!outputLib:?}/lib/stubs"
        exit 1
      }
    '';

    # Tell autoPatchelf about runtime dependencies.
    postFixup = ''
      nixLog "patchelf-ing ''${!outputBin:?}/bin/trtexec with runtime dependencies"
      patchelf \
        "''${!outputBin:?}/bin/trtexec" \
        --add-needed libnvinfer_plugin.so.${majorVersion}
    '';

    passthru = {
      # The CUDNN used with TensorRT.
      inherit cudnn;
    };

    meta = {
      description = "SDK that facilitates high-performance machine learning inference";
      longDescription = ''
        NVIDIA TensorRT is an SDK that facilitates high-performance machine learning inference. It complements training
        frameworks such as TensorFlow, PyTorch, and MXNet. It focuses on running an already-trained network quickly and
        efficiently on NVIDIA hardware.
      '';
      homepage = "https://developer.nvidia.com/tensorrt";
      # NOTE: As of 2025-08-31, TensorRT doesn't follow the standard naming convention for URL paths that the rest of
      # the redistributables do. As such, we need to specify downloadPage manually.
      downloadPage = "https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt";
      changelog = "https://docs.nvidia.com/deeplearning/tensorrt/latest/getting-started/release-notes.html#release-notes";

      license = _cuda.lib.licenses.tensorrt;
    };
  }
)
