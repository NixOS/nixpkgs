{ stdenv
, bash
, buildPackages
, buildBazelPackage
, fetchFromGitHub
, lib
}:
let
  buildPlatform = stdenv.buildPlatform;
  hostPlatform = stdenv.hostPlatform;
  pythonEnv = buildPackages.python3.withPackages (ps: [ ps.numpy ]);
  bazelDepsSha256ByBuildAndHost = {
    x86_64-linux = {
      x86_64-linux = "sha256-61qmnAB80syYhURWYJOiOnoGOtNa1pPkxfznrFScPAo=";
      aarch64-linux = "sha256-sOIYpp98wJRz3RGvPasyNEJ05W29913Lsm+oi/aq/Ag=";
    };
    aarch64-linux = {
      aarch64-linux = "sha256-MJU4y9Dt9xJWKgw7iKW+9Ur856rMIHeFD5u05s+Q7rQ=";
    };
  };
  bazelHostConfigName.aarch64-linux = "elinux_aarch64";
  bazelDepsSha256ByHost =
    bazelDepsSha256ByBuildAndHost.${buildPlatform.system} or
      (throw "unsupported build system ${buildPlatform.system}");
  bazelDepsSha256 = bazelDepsSha256ByHost.${hostPlatform.system} or
      (throw "unsupported host system ${hostPlatform.system} with build system ${buildPlatform.system}");
in
buildBazelPackage rec {
  name = "tensorflow-lite";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "tensorflow";
    rev = "v${version}";
    hash = "sha256-Rq5pAVmxlWBVnph20fkAwbfy+iuBNlfFy14poDPd5h0=";
  };

  bazel = buildPackages.bazel_5;

  nativeBuildInputs = [ pythonEnv buildPackages.perl ];

  bazelTargets = [
    "//tensorflow/lite:libtensorflowlite.so"
    "//tensorflow/lite/c:tensorflowlite_c"
    "//tensorflow/lite/tools/benchmark:benchmark_model"
    "//tensorflow/lite/tools/benchmark:benchmark_model_performance_options"
  ];

  bazelFlags = [
    "--config=opt"
  ] ++ lib.optionals (hostPlatform.system != buildPlatform.system) [
    "--config=${bazelHostConfigName.${hostPlatform.system}}"
  ];

  bazelBuildFlags = [ "--cxxopt=--std=c++17" ];

  buildAttrs = {
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

  fetchAttrs.sha256 = bazelDepsSha256;

  PYTHON_BIN_PATH = pythonEnv.interpreter;

  dontAddBazelOpts = true;
  removeRulesCC = false;

  postPatch = ''
    rm .bazelversion

    # Fix gcc-13 build failure by including missing include headers
    sed -e '1i #include <cstdint>' -i \
      tensorflow/lite/kernels/internal/spectrogram.cc
  '';

  preConfigure = ''
    patchShebangs configure
  '';

  # configure script freaks out when parameters are passed
  dontAddPrefix = true;
  configurePlatforms = [];

  meta = with lib; {
    description = "An open source deep learning framework for on-device inference";
    homepage = "https://www.tensorflow.org/lite";
    license = licenses.asl20;
    maintainers = with maintainers; [ mschwaig cpcloud ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
