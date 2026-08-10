{
  stdenv,
  buildPackages,
  buildBazelPackage,
  fetchFromGitHub,
  lib,
}:
let
  buildPlatform = stdenv.buildPlatform;
  hostPlatform = stdenv.hostPlatform;
  pythonEnv = buildPackages.python3.withPackages (
    ps: with ps; [
      distutils
      numpy
    ]
  );
  bazelDepsSha256ByBuildAndHost = {
    x86_64-linux = {
      x86_64-linux = "sha256-vf7lvxiCUK8mnm+pFj1h30MYiyMTDQ9eGBVrsLa27aM=";
      aarch64-linux = "sha256-J/WgmhmjB98JrQS0us8zIP34YqaSRZ2fwKISGJud148=";
    };
    aarch64-linux = {
      aarch64-linux = "sha256-J/WgmhmjB98JrQS0us8zIP34YqaSRZ2fwKISGJud148=";
    };
  };
  bazelHostConfigName.aarch64-linux = "elinux_aarch64";
  bazelDepsSha256ByHost =
    bazelDepsSha256ByBuildAndHost.${buildPlatform.system}
      or (throw "unsupported build system ${buildPlatform.system}");
  bazelDepsSha256 =
    bazelDepsSha256ByHost.${hostPlatform.system}
      or (throw "unsupported host system ${hostPlatform.system} with build system ${buildPlatform.system}");
in
buildBazelPackage rec {
  name = "tensorflow-lite";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "tensorflow";
    rev = "v${version}";
    hash = "sha256-Hs3g80wSHex1ejz7H8eu6MJMzwthx58sPGDh/dG66FQ=";
  };

  bazel = buildPackages.bazel_7; # from .bazelversion

  nativeBuildInputs = [
    pythonEnv
    buildPackages.perl
  ];

  bazelTargets = [
    "//tensorflow/lite:libtensorflowlite.so"
    "//tensorflow/lite/c:tensorflowlite_c"
    "//tensorflow/lite/tools/benchmark:benchmark_model"
    "//tensorflow/lite/tools/benchmark:benchmark_model_performance_options"
  ];

  bazelFlags = [
    "--config=opt"
  ]
  ++ lib.optionals (hostPlatform.system != buildPlatform.system) [
    "--config=${bazelHostConfigName.${hostPlatform.system}}"
  ];

  bazelBuildFlags = [ "--cxxopt=--std=c++17" ];

  buildAttrs = {
    preConfigure =
      # Fix #!/usr/bin/env shebangs in rules_python -- Bazel-generated Python
      # stubs use #!/usr/bin/env which doesn't exist in the nix sandbox
      ''
        substituteInPlace $bazelOut/external/rules_python/python/private/py_runtime_info.bzl \
          --replace-fail '"#!/usr/bin/env python3"' '"#!${pythonEnv}/bin/python3"'
        substituteInPlace $bazelOut/external/rules_python/python/private/runtime_env_toolchain.bzl \
          --replace-fail '"#!/usr/bin/env python3"' '"#!${pythonEnv}/bin/python3"'
      ''
      # Re-patchelf hermetic Python binary with the nix dynamic linker
      # (was normalized in fetchAttrs for reproducibility)
      + ''
        for py_dir in $bazelOut/external/python_3_*; do
          if [ -d "$py_dir" ]; then
            find "$py_dir" -type f -executable -exec \
              patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} {} \; 2>/dev/null || true
          fi
        done
      '';

    installPhase = ''
      mkdir -p $out/{bin,lib}

      # copy the libs and binaries into the output dir
      cp ./bazel-bin/tensorflow/lite/c/libtensorflowlite_c.so $out/lib
      cp ./bazel-bin/tensorflow/lite/libtensorflowlite.so $out/lib
      cp ./bazel-bin/tensorflow/lite/tools/benchmark/benchmark_model $out/bin
      cp ./bazel-bin/tensorflow/lite/tools/benchmark/benchmark_model_performance_options $out/bin

      find . -type f -name '*.h' | while read f; do
        path="$out/include/''${f/.\//}"
        install -D "$f" "$path"

        # remove executable bit from headers
        chmod -x "$path"
      done
    '';
  };

  fetchAttrs = {
    sha256 = bazelDepsSha256;

    preInstall =
      # Note: $bazelOut/external is the entire contents of the deps archive (see
      # `deps.installPhase` in buildBazelPackage).
      ''
        chmod -R u+w $bazelOut/external
      ''
      # Remove local_config_sh* that contains hardcoded paths to /nix/store
      + ''
        rm -rf $bazelOut/external/{local_config_shell,local_config_sh}
      ''
      # Delete non-deterministic Python bytecode (contains timestamps)
      + ''
        find $bazelOut/external -name '*.pyc' -delete
      '';
  };

  env = {
    PYTHON_BIN_PATH = pythonEnv.interpreter;
    HERMETIC_PYTHON_VERSION = "3.13";
    TF_NEED_CLANG = "0";
    TF_NEED_CUDA = "0";
    TF_NEED_ROCM = "0";
    TF_SET_ANDROID_WORKSPACE = "0";
  };

  dontAddBazelOpts = true;
  removeRulesCC = false;

  # tf_workspace0 loads @local_config_android//:android.bzl, so the local_*
  # repositories have to survive into the build phase.
  removeLocal = false;

  postPatch =
    # Remove the .bazelversion file to allow our Bazel version
    ''
      rm .bazelversion
    ''
    # Remove rules_ml_toolchain's hermetic CC toolchain registrations.
    # These try to lazily download LLVM binaries during analysis, which
    # fails in the sandboxed build phase. We use our own compiler from nixpkgs instead.
    + ''
      sed -i '/^register_toolchains("@rules_ml_toolchain/d' WORKSPACE
    '';

  preConfigure = ''
    patchShebangs configure
  '';

  # configure script freaks out when parameters are passed
  dontAddPrefix = true;
  configurePlatforms = [ ];

  meta = {
    description = "Open source deep learning framework for on-device inference";
    homepage = "https://www.tensorflow.org/lite";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mschwaig
      cpcloud
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
