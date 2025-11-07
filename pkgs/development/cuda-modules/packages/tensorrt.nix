{
  _cuda,
  backendStdenv,
  buildRedist,
  cuda_cudart,
  cudaAtLeast,
  cudaMajorMinorVersion,
  lib,
  libcudla, # only for Jetson
  patchelf,
}:
let
  inherit (backendStdenv) cudaCapabilities hostRedistSystem;
  inherit (lib.lists) optionals;
  inherit (lib.strings) concatStringsSep;
in
buildRedist (
  finalAttrs:
  let
    majorVersion = lib.versions.major finalAttrs.version;

    tensorrtAtLeast = lib.versionAtLeast finalAttrs.version;
    tensorrtOlder = lib.versionOlder finalAttrs.version;

    # Create variables and use logical OR to allow short-circuiting.
    tensorrtAtLeast105 = tensorrtAtLeast "10.5.0";
    tensorrtAtLeast100 = tensorrtAtLeast105 || tensorrtAtLeast "10.0.0";

    allCCNewerThan75 = lib.all (lib.flip lib.versionAtLeast "7.5") cudaCapabilities;
    allCCNewerThan70 = allCCNewerThan75 || lib.all (lib.flip lib.versionAtLeast "7.0") cudaCapabilities;

    cudaCapabilitiesJSON = builtins.toJSON cudaCapabilities;
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
    ]
    # From 10.14.1, TensorRT samples are distributed through the TensorRT GitHub repository.
    ++ optionals (tensorrtOlder "10.14.1") [
      "samples"
    ]
    ++ [
      "static"
      # "stubs" removed in postInstall
    ];

    allowFHSReferences = true;

    nativeBuildInputs = [ patchelf ];

    buildInputs = [
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
          nixLog "replacing symlink $PWD/$dir with $PWD/targets/${targetString}/$dir"
          rm --verbose "$PWD/$dir"
          mv --verbose --no-clobber "$PWD/targets/${targetString}/$dir" "$PWD/$dir"
        done
        unset -v dir
      ''
      # Remove symlinks if they exist
      + ''
        for dir in include samples; do
          if [[ -L "$PWD/targets/${targetString}/$dir" ]]; then
            nixLog "removing symlink $PWD/targets/${targetString}/$dir"
            rm --verbose "$PWD/targets/${targetString}/$dir"
          fi
        done
        unset -v dir

        if [[ -d "$PWD/targets" ]]; then
          nixLog "removing targets directory"
          rm --recursive --verbose "$PWD/targets" || {
            nixErrorLog "could not delete $PWD/targets: $(ls -laR "$PWD/targets")"
            exit 1
          }
        fi
      '';

    autoPatchelfIgnoreMissingDeps =
      optionals (hostRedistSystem == "linux-aarch64") [
        "libnvdla_compiler.so"
      ]
      ++ optionals (tensorrtAtLeast "10.13.3") [
        "libcuda.so.1"
      ];

    # Create a symlink for the Onnx header files in include/onnx
    # NOTE(@connorbaker): This is shared with the tensorrt-oss package, with the `out` output swapped with `include`.
    # When updating one, check if the other should be updated.
    # TODO(@connorbaker): It seems like recent versions of TensorRT have separate libs for separate capabilities;
    # we should remove libraries older than those necessary to support requested capabilities.
    postInstall = ''
      mkdir "''${!outputInclude:?}/include/onnx"
      pushd "''${!outputInclude:?}/include" >/dev/null
      nixLog "creating symlinks for Onnx header files"
      ln -srvt "''${!outputInclude:?}/include/onnx/" NvOnnx*.h
      popd >/dev/null
    ''
    # Move the python directory, which contains header files, to the include output.
    # NOTE: Python wheels should be built from source using the TensorRT GitHub repo.
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
      nixLog "removing any Windows libraries"
      for winLib in "''${!outputLib:?}/lib/"*_win*; do
        rm --verbose "$winLib"
      done
      unset -v winLib
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

    # NOTE: Like cuDNN, NVIDIA offers forward compatibility within a major releases of CUDA.
    platformAssertions = [
      {
        message =
          "tensorrt releases since 10.0.0 (found ${finalAttrs.version})"
          + " support CUDA compute capabilities 7.0 and newer (found ${cudaCapabilitiesJSON})";
        assertion = tensorrtAtLeast100 -> allCCNewerThan70;
      }
      {
        message =
          "tensorrt releases since 10.0.0 (found ${finalAttrs.version})"
          + " support only CUDA compute capability 8.7 (Jetson Orin) for pre-Thor Jetson devices"
          + " (found ${cudaCapabilitiesJSON})";
        assertion =
          tensorrtAtLeast100 && hostRedistSystem == "linux-aarch64" -> cudaCapabilities == [ "8.7" ];
      }
      {
        message =
          "tensorrt releases since 10.0.0 (found ${finalAttrs.version})"
          + " support CUDA 12.4 and newer for pre-Thor Jetson devices (found ${cudaMajorMinorVersion})";
        assertion = tensorrtAtLeast100 && hostRedistSystem == "linux-aarch64" -> cudaAtLeast "12.4";
      }
      {
        message =
          "tensorrt releases since 10.5.0 (found ${finalAttrs.version})"
          + " support CUDA compute capabilities 7.5 and newer (found ${cudaCapabilitiesJSON})";
        assertion = tensorrtAtLeast105 -> allCCNewerThan75;
      }
    ];

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
